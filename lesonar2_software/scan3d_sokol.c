#define HANDMADE_MATH_IMPLEMENTATION
//#define HANDMADE_MATH_NO_SSE
#include "HandmadeMath.h"
#define SOKOL_IMPL
#define SOKOL_GLCORE33
#include "sokol_gfx.h"
#include "sokol_log.h"
#include "sokol_time.h"
#include "glfw_glue.h"



#define N 64


#include <stdlib.h>
#include <stdint.h>
#include <complex.h>
#include <stdbool.h>
#include <math.h>


#include <stdio.h>
#include <string.h>

#include <fftw3.h>
#include "colormap.h"
#include "protocol.h"



enum {
    MAX_PARTICLES = 100*N*N,
    NUM_PARTICLES_EMITTED_PER_FRAME = 10
};

// vertex shader uniform block
typedef struct {
    hmm_mat4 mvp;
} vs_params_t;

// particle positions and velocity
int cur_num_particles = 0;
float pos_colors_reversed[MAX_PARTICLES*7];
float pos_colors[MAX_PARTICLES*7];

hmm_vec3 vel[MAX_PARTICLES];


void print_arr_fftw_complex(fftw_complex *arr) {
    for(int i = 0; i < N ; i++) {
        for(int j = 0; j < N ; j++) {
            fftw_complex a = arr[i*N+j];
            printf("%f + i%f,\t", creal(a), cimag(a));
        }
        printf("\n");
    }
}


float hann(int i, int length) {
    return 0.5 * (1 - cos(2*M_PI*i/(length-1)));
}

void normalize_arr_fftw_complex(fftw_complex *arr, int size) {
    fftw_complex max = arr[0];
    fftw_complex min = arr[0];
    for(unsigned int i = 0;  i < size ; i++) {
        float val = cabsf(arr[i]);
        if(val > cabsf(max)) {
            max = arr[i];
        }
        if(val < cabsf(min)) {
            min = arr[i];
        }
    }
    float delta = max-min;
    for(unsigned int i = 0; i < size ; i++) {
        arr[i] = (arr[i]-min)/delta;
    }
}

void normalize_arr_float(float *arr, int size) {
    float max = arr[0];
    float min = arr[0];
    for(unsigned int i = 0; i < size ; i++) {
        float val = arr[i];
        if(val > max) {
            max = arr[i];
        }
        if(val < min) {
            min = arr[i];
        }
    }
    float delta = max-min;
    for(unsigned int i = 0; i < size ; i++) {
        arr[i] = (arr[i]-min)/delta;
    }
}

// Computes the circular 2d convolution of in1 and in2 and puts the output in out
void circular_2d_convolution(fftw_complex *in1, fftw_complex *in2, fftw_complex *buf1,  fftw_plan plan, fftw_plan inv_plan, fftw_complex *out) {
    fftw_execute_dft(plan, in1, buf1);
    fftw_execute_dft(plan, in2, out);
    for(int i = 0; i < N*N; i++ ) {
        buf1[i] *= out[i];
    }
    fftw_execute_dft(inv_plan, buf1, out);
}


// Computes the circular 2d convolution of in1 and in2, but here we're assuming in2
// is already in the spatial frequency domain (psf doesn't change, so we can compute it only once)
void partial_circular_2d_convolution(fftw_complex *in1, fftw_complex *in2, fftw_complex *buf1,  fftw_plan plan, fftw_plan inv_plan, fftw_complex *out) {
    fftw_execute_dft(plan, in1, buf1);
    for(int i = 0; i < N*N; i++ ) {
        buf1[i] *= in2[i];
    }
    fftw_execute_dft(inv_plan, buf1, out);
}

typedef struct richardson_lucy_context {
    int n_iterations;
    fftw_complex *buf1;
    fftw_complex *psf;
    fftw_complex *psf_dft;
    fftw_complex *est_conv;
    fftw_complex *relative_blur;
    fftw_complex *relative_correction;
    fftw_complex *im_deconv;
    fftw_complex *final;

    fftw_plan plan;
    fftw_plan inv_plan;
} richardson_lucy_context;


void init_richardson_lucy_context(richardson_lucy_context *rl_ctx, int n_iterations) {
    rl_ctx->n_iterations = n_iterations;

    rl_ctx->buf1 = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->buf1) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->buf1[i] = 0.0 +0.0;

    rl_ctx->psf = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->psf) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->psf[i] = 0;


    rl_ctx->psf_dft = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->psf_dft) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->psf_dft[i] = 0;

    rl_ctx->est_conv = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->est_conv) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->est_conv[i] = 0;

    rl_ctx->relative_blur= (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->relative_blur) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->relative_blur[i] = 0;

    rl_ctx->relative_correction = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->relative_correction) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->relative_correction[i] = 0;
    printf("125\n");

    rl_ctx->im_deconv = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->im_deconv) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->im_deconv[i] = 0;
    printf("130\n");

    rl_ctx->final = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    if (!rl_ctx->final) goto cleanup;
    for(int i = 0; i < N*N; i++)
        rl_ctx->final[i] = 0;

    rl_ctx->plan     = fftw_plan_dft_2d(N, N, rl_ctx->buf1, rl_ctx->psf, FFTW_FORWARD, FFTW_MEASURE);
    if (!rl_ctx->plan) goto cleanup;

    rl_ctx->inv_plan = fftw_plan_dft_2d(N, N, rl_ctx->psf_dft, rl_ctx->buf1, FFTW_BACKWARD, FFTW_MEASURE);
    if (!rl_ctx->inv_plan) goto cleanup;

    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            rl_ctx->buf1[i*N+j] = i < 20 && j < 20 ? hann(i, 20) * hann(j, 20) : 0.0;
        }
    }

    fftw_execute_dft(rl_ctx->plan, rl_ctx->buf1, rl_ctx->psf);
    normalize_arr_fftw_complex(rl_ctx->psf, N*N);
    for(unsigned int i = 0; i < N ; i++)
        for(unsigned int j = 0; j < N ; j++)
            rl_ctx->psf[i*N+j] = cabsf(rl_ctx->psf[i*N+j]) + I*0.0f;

    fftw_execute_dft(rl_ctx->plan, rl_ctx->psf, rl_ctx->psf_dft);

    return;
    cleanup:
        printf("memory alloc issue!\n");
        exit(-1);

}

void apply_richardson_lucy(richardson_lucy_context *rl_ctx, fftw_complex *in, fftw_complex *out) {
    for(int i = 0; i < N*N; i++) {
        rl_ctx->im_deconv[i] = in[i];
    }
    for(int k = 0; k < rl_ctx->n_iterations; k++) {
        // est_conv = convolve(im_deconv, psf, mode='same') + eps
        partial_circular_2d_convolution(rl_ctx->im_deconv, rl_ctx->psf_dft, rl_ctx->buf1, rl_ctx->plan, rl_ctx->inv_plan, rl_ctx->est_conv);


        // relative_blur = image / conv
        for(int i = 0; i < N*N ; i++)
            rl_ctx->relative_blur[i] = in[i] / (rl_ctx->est_conv[i] + 1e-12);

        // im_deconv *= convolve(relative_blur, psf_mirror, mode='same')
        partial_circular_2d_convolution(rl_ctx->relative_blur, rl_ctx->psf_dft, rl_ctx->buf1, rl_ctx->plan, rl_ctx->inv_plan, rl_ctx->relative_correction);
        for(int i = 0; i < N*N ; i++)
            rl_ctx->im_deconv[i] *= rl_ctx->relative_correction[i];
    }
    for(int i = 0; i < N*N; i++) {
        out[i] = rl_ctx->im_deconv[i];
    }

}



int main(int argc, char **argv) {
    float current_gain = 4.5;

    stm_setup();
    uint64_t time_prev = stm_now();

    sonar_protocol_context sonar_protocol_ctx;
    init_sonar_protocol_ctx(&sonar_protocol_ctx, argc > 1);


    if(argc > 1) {
        printf("Opening recording at %s\n", argv[1]);
        get_frames_from_disk(&sonar_protocol_ctx, argv[1]);
    }


    bool drawing = false;
    bool drawn[750];


    // create window and GL context via GLFW
    glfw_init(&(glfw_desc_t){ .title = "LeSonar 2 3D", .width = 800, .height = 600, .sample_count = 4 }); // setup sokol_gfx
    sg_setup(&(sg_desc){
            .environment = glfw_environment(),
            .logger.func = slog_func,
            });
    assert(sg_isvalid());

    // vertex buffer for static geometry (goes into vertex buffer bind slot 0)
    const float r = 129.0/(2*N)*3.14/180.0;




    //
    const float vertices[] = {
        // positions            colors
        0.0f, -r, -r,       1.0f, 0.0f, 0.0f, 1.0f,
        0.0f, r, -r,       0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, r, r,         0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, r, r,         1.0f, 1.0f, 0.0f, 1.0f,
        0.0f, -r, r,        0.0f, 1.0f, 1.0f, 1.0f,
        0.0f, -r, -r,       1.0f, 0.0f, 1.0f, 1.0f
    };

    glfwSwapInterval(0);

    sg_buffer vbuf_geom = sg_make_buffer(&(sg_buffer_desc){
            .data = SG_RANGE(vertices)
            });

    // index buffer for static geometry
    const uint16_t indices[] = {
        0, 1, 2,    0, 2, 3,    0, 3, 4,    0, 4, 1,
        5, 1, 2,    5, 2, 3,    5, 3, 4,    5, 4, 1
    };
    sg_buffer ibuf = sg_make_buffer(&(sg_buffer_desc){
            .type = SG_BUFFERTYPE_INDEXBUFFER,
            .data = SG_RANGE(indices)
            });

    // empty, dynamic instance-data vertex buffer (goes into vertex buffer bind slot 1)
    sg_buffer vbuf_inst = sg_make_buffer(&(sg_buffer_desc){
            .size = MAX_PARTICLES * 7* sizeof(float),
            .usage = SG_USAGE_STREAM
            });



    // create a shader
    sg_shader shd = sg_make_shader(&(sg_shader_desc){
            .vs.uniform_blocks[0] = {
            .size = sizeof(vs_params_t),
            .uniforms = {
            [0] = { .name="mvp", .type=SG_UNIFORMTYPE_MAT4 }
            }
            },
            .vs.source =
            "#version 330\n"
            "uniform mat4 mvp;\n"
            "layout(location=0) in vec3 position;\n"
            "layout(location=1) in vec4 color0;\n"
            "layout(location=2) in vec3 instance_pos;\n"
            "layout(location=3) in vec4 instance_color;\n"
            "out vec4 color;\n"
            "void main() {\n"
            // "  vec4 pos = vec4(position * 3.14*((gl_InstanceID+1)/(32*32)*0.008) + instance_pos, 1.0);"
            "  float r = length(instance_pos);"
            "  vec4 pos = vec4(position*r + instance_pos, 1.0);"
            "  gl_Position = mvp * pos;\n"
            "  color = instance_color;\n"
            "}\n",
            .fs.source =
                "#version 330\n"
                "in vec4 color;\n"
                "out vec4 frag_color;\n"
                "void main() {\n"
                "  frag_color = color;\n"
                "}\n",
    });

    // pipeline state object, note the vertex layout definition
    sg_pipeline pip = sg_make_pipeline(&(sg_pipeline_desc){
            .layout = {
            .buffers = {
            [0] = { .stride = 28 },
            [1] = { .stride = (3+4)*4, .step_func=SG_VERTEXSTEP_PER_INSTANCE }
            },
            .attrs = {
            [0] = { .offset = 0,  .format=SG_VERTEXFORMAT_FLOAT3, .buffer_index=0 },
            [1] = { .offset = 12, .format=SG_VERTEXFORMAT_FLOAT4, .buffer_index=0 },
            [2] = { .offset = 0,  .format=SG_VERTEXFORMAT_FLOAT3, .buffer_index=1 },
            [3] = { .offset = 12,  .format=SG_VERTEXFORMAT_FLOAT4, .buffer_index=1 }
            }
            },
            .shader = shd,
            .colors[0] = {
            .write_mask = SG_COLORMASK_RGB,
            .blend = {
            .enabled = true,
            .src_factor_rgb = SG_BLENDFACTOR_SRC_ALPHA,
            .dst_factor_rgb = SG_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
            }
            },

            .index_type = SG_INDEXTYPE_UINT16,
            .depth = {
                .compare = SG_COMPAREFUNC_LESS_EQUAL,
                .write_enabled = true
            },
            .cull_mode = SG_CULLMODE_BACK
    });

    // setup resource bindings, note how the instance-data buffer goes into vertex buffer slot 1
    sg_bindings bind = {
        .vertex_buffers = {
            [0] = vbuf_geom,
            [1] = vbuf_inst
        },
        .index_buffer = ibuf
    };

    // draw loop
    vs_params_t vs_params;
    float roty = 90.0f;
    const float frame_time = 1.0f / 60.0f;
    int index_buf = 0;

// ---------------------- INIT FFTW3

    fftw_complex *in, *out, *signal_3d;
    signal_3d = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * 20 * 20 * L);
    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
//    fftw_plan plan = fftw_plan_dft_2d(N, N, in, out, FFTW_BACKWARD, FFTW_MEASURE);
//    if(!plan) {
//        printf("Couldn't create plan");
//        exit(-1);
//    }

    richardson_lucy_context rl_ctx;
    init_richardson_lucy_context(&rl_ctx, 10);
    // ---------------------- END INIT FFTW3

    sg_pass_action pass_action = {
        .colors[0] = { .load_action=SG_LOADACTION_CLEAR, .clear_value={1.0f, 1.0f, 1.0f, 1.0f} }
    };

    while (!glfwWindowShouldClose(glfw_window())) {
        // Wait for transfer to finish
        player_cmd_t player_cmd = CMD_STEP;

        int current_particle = 0;
//        for(int k = 0; k < L*20*20; k++)
 //       signal_3d[k] = 0.0;


        get_sonar_frame(&sonar_protocol_ctx, signal_3d, player_cmd);
        for(int k = 60; k < 350; k+= 5) {
            for(int i = 0; i < N*N; i++) {
                in[i] = 0.0;
            }
            for(int i = 0; i < 20; i++) {
                for(int j = 0; j < 20; j++) {
                    in[i*N+j] = hann(i, 20) * hann(j, 20) * signal_3d[k*20*20+i*20+j];
                }
            }

            fftw_execute_dft(rl_ctx.plan, in, out);

//           apply_richardson_lucy(&rl_ctx, out, in);


            for(unsigned int i = 0; i < N; i++) {
                for(unsigned int j = 0 ; j < N; j++) {
                    int value;
                    value = (int)(cabsf(out[i*N+j])*(current_gain));


                    float r = (float) k*0.008;
                    value *= r/75;
                    if(value < 0) value = 0; if(value > 255) value = 255;


                    int scale = 255;//(val_f/max_val-1)*255;
                    int l = current_particle;//MAX_PARTICLES-(channel_number*N*N+i*N+j);
                    if(value > 100) {

                        float x = (i+N/2)%N;
                        float y = (j+N/2)%N;


                        float theta = -atan(2*(float)((y-N/2)/N));
                        float phi   = atan(2*(float)((x-N/2)/N));

                        float dtheta = 3.14/N; // theta+(float)((j+1)-N/2)*129/N*3.14f/180.0f ;
                        float dphi = dtheta;





                        int intensity = value; //channel_number*3/2;

                        pos_colors_reversed[l*7+0] = r*cosf(phi) * cosf(theta);
                        pos_colors_reversed[l*7+1] = r*sinf(theta);
                        pos_colors_reversed[l*7+2] = r*sinf(phi);


                        pos_colors_reversed[l*7+3] = inferno[(int)(r*75)][0];
                        pos_colors_reversed[l*7+4] = inferno[(int)(r*75)][1];
                        pos_colors_reversed[l*7+5] = inferno[(int)(r*75)][2];
                        pos_colors_reversed[l*7+6] = (float)value /255.0/2.0;
                        if(current_particle < MAX_PARTICLES)
                            current_particle++;
                    }
                }
            }

        }



        for(int i = 0; i < current_particle; i++) {
            for(int j = 0; j < 7; j++) {
                pos_colors[(current_particle-i)*7+j] = pos_colors_reversed[i*7+j];
            }
        }


        drawing = false;
        printf("DRAWING\n");


        // view-projection matrix
        hmm_mat4 proj = HMM_Perspective(130.0f, (float)glfw_width()/(float)glfw_height(), 0.01f, 50.0f);
        hmm_mat4 view = HMM_LookAt(HMM_Vec3(0.0f, 0.0f, 0.1), HMM_Vec3(0.0f, 0.0f, 0.0f), HMM_Vec3(0.0f, 1.0f, 0.0f));
        hmm_mat4 view_proj = HMM_MultiplyMat4(proj, view);

        // update instance data
        sg_update_buffer(bind.vertex_buffers[1], &(sg_range) {
                .ptr = pos_colors,
                .size = (size_t)(current_particle+1) * 7 * sizeof(float)
                });

        vs_params.mvp = HMM_MultiplyMat4(view_proj, HMM_Rotate(roty, HMM_Vec3(0.0f, 1.0f, 0.0f)));;
        sg_begin_pass(&(sg_pass){ .action = pass_action, .swapchain = glfw_swapchain() });
        sg_apply_pipeline(pip);
        sg_apply_bindings(&bind);
        sg_apply_uniforms(SG_SHADERSTAGE_VS, 0, &SG_RANGE(vs_params));
        sg_draw(0, 24, current_particle);
        sg_end_pass();
        sg_commit();
        glfwSwapBuffers(glfw_window());
        glfwPollEvents();
        //while(stm_ms(stm_now()-time_prev) < 19);
        time_prev = stm_now();

        printf("current_particle=%d\n", current_particle);
        current_particle = 0;

    }

    // cleanup
    sg_shutdown();
}
