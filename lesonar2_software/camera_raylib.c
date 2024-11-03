#include <stdlib.h>
#include <stdint.h>
#include <complex.h>
#include <stdbool.h>


#include <stdio.h>
#include <string.h>

// Linux headers
#include <fftw3.h>


#include "colormap.h"
#include "raylib.h"

#include "protocol.h"

#define N 128

#define WINDOW_HEIGHT 640
#define WINDOW_WIDTH  640

void draw_value(int i, int j, int value, float pixel_size, bool fftshift) {
    if(value < 0) value = 0;
    if(value > 255) value = 255;

    int rgb_scale = 255;
    int scale = 255;//(val_f/max_val-1)*255;
    Color c = (Color) {inferno[value][0]*scale , inferno[value][1]*scale, inferno[value][2]*scale, rgb_scale };
    int x = fftshift ? (i+N/2)%N : i;
    int y = fftshift ? (j+N/2)%N : j;
    DrawRectangle(
            x*pixel_size, // X
            y*pixel_size, // Y
            pixel_size,           // Width
            pixel_size,           // Height
            c
            );
}

int main(int argc, unsigned char **argv) {
    sonar_protocol_context sonar_protocol_ctx;
    init_sonar_protocol_ctx(&sonar_protocol_ctx, argc > 1);
    if(argc > 1) {
        printf("Opening recording at %s\n", argv[1]);
        get_frames_from_disk(&sonar_protocol_ctx, argv[1]);
//        SetTargetFPS(52);
    }


    float defilement = 0.0;
    int current_view = 0;
    InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "GUI Mosquitorgnole");

    float current_gain = 1;
    int current_idx = 1;
    int current_sample = 0;
    bool recording = false;
    bool continuer = true;

    fftw_complex *in, *out, *signal_3d;
    signal_3d = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * 20 * 20 * L);
    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N * N);
    fftw_plan plan = fftw_plan_dft_2d(N, N, in, out, FFTW_BACKWARD, FFTW_MEASURE);



    int index_buf = 0;
    bool pause = false;
    while(!WindowShouldClose()) {
        player_cmd_t player_cmd = CMD_STEP;
        if(IsKeyPressed(KEY_SPACE)) {
            pause = !pause;
            printf("pause = %d\n", pause);
        }
        if(pause) {
            player_cmd = CMD_PAUSE;
            if(IsKeyPressed(KEY_LEFT))  player_cmd = CMD_BACK;
            if(IsKeyPressed(KEY_RIGHT)) player_cmd = CMD_STEP;
        }


        get_sonar_frame(&sonar_protocol_ctx, signal_3d, player_cmd);

        if(IsKeyPressed(KEY_R))
            dump_frames(
                    &sonar_protocol_ctx.recording_buf_ctx);

        for(unsigned int i = 0; i < 20; i++) {
            for(unsigned int j = 0 ; j < 20; j++) {
                in[i*N+j] = signal_3d[current_sample*20*20+i*20+j];

            }
        }

        fftw_execute(plan);
        BeginDrawing();
        if(IsKeyPressed(KEY_UP))    current_gain *= 2;
        if(IsKeyPressed(KEY_DOWN))  current_gain /= 2;


        if(IsKeyPressed(KEY_LEFT))  current_sample += 1;
        if(IsKeyPressed(KEY_RIGHT)) current_sample -= 1;

        if(IsKeyPressed(KEY_L)) current_idx += 20;
        if(IsKeyPressed(KEY_H)) current_idx -= 20;
        if(IsKeyPressed(KEY_K)) current_idx -= 1;
        if(IsKeyPressed(KEY_J)) current_idx += 1;

        if(IsKeyPressed(KEY_R)) {
            recording = !recording;
            if(recording) printf("recording started\n");
            else          printf("recording stopped\n");
        }

        if(IsKeyPressed(KEY_V)) {
            if(current_view < 3) current_view += 1;
            else                 current_view = 0;
        }

        if(IsKeyPressed(KEY_S))
            printf("current_idx = %d, current_gain = %f, current_view=%d, current_sample=%d, defilement=%f\n", current_idx, current_gain, current_view, current_sample, defilement);


        ClearBackground(RAYWHITE);

        for(unsigned int i = 0; i < N; i++) {
            for(unsigned int j = 0 ; j < N; j++) {
                int value = 0;
                float pixel_size = WINDOW_HEIGHT/N;
                bool fftshift = false;
                if(current_view == 0) {
                    fftshift = true;
                    pixel_size = WINDOW_HEIGHT/N;
                    value = (int)(cabsf(out[i*N+j])*(current_gain/10));
                    draw_value(i, j, value, pixel_size, fftshift);
                } else if (current_view == 3) {
                    fftshift = true;
                    pixel_size = WINDOW_HEIGHT/N;
                    float phase = cargf(out[i*N+j]) + cargf(cexp(-I*3.14*(i+j)/10.0));
                    if(phase > 3.1416f) {
                        phase -= 2.0f*3.1416f;
                    } else if (phase < - 3.1516f) {
                        phase += 3.1415f*2.0f;
                    }

                    int amplitude = (int)(cabsf(out[i*N+j])*(current_gain/10));
                    if(amplitude > 128) {
                        value = (int)(phase+3.16f)/(6.28f)*(255);
                    } else {
                        value = 0;
                    }
                    draw_value(i, j, value, pixel_size, fftshift);
                } else if (i < 20 && j < 20) {
                    if(current_view == 1) {
                        pixel_size = WINDOW_HEIGHT/20.0;
                        value = (int)(cabsf(in[i*N+j])*(current_gain));
                        if(i == 19) {
                            value = j*255/20;
                        }
                    } else if (current_view == 2) {
                        pixel_size = WINDOW_HEIGHT/20.0;
                        float phase = cargf(in[i*N+j]) - cargf(in[0]) ;
                        if(phase > 3.1416f) {
                            phase -= 2.0f*3.1416f;
                        } else if (phase < - 3.1516f) {
                            phase += 3.1415f*2.0f;
                        }
                        value = (int)((phase+3.16f)/(6.28f)*(current_gain*128*128));
                    }

                    draw_value(i, j, value, pixel_size, fftshift);
                }

            }
        }
        DrawFPS(10, 10);
        EndDrawing();
    }

    CloseWindow();
    return 0;

}
