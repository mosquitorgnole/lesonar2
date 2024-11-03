#ifndef PROTOCOL
#define PROTOCOL

#include <stdbool.h>
#include <stdio.h>
#include "ftd3xx.h"
#include "circularbuffer.h"

#define BUFFER_SIZE (751*(380*4+4))
#define NUM_BUFFERS 5
#define FIFO_CHANNEL_1	0
#define TIMEOUT			0 //0xFFFFFFFF
#define L (751)
#define NUM_CHANNELS (380*2)

#define RECORDING_BUFFER_LEN (256*256*8) // (50*750*(380*4+4))
#define RECORDING_BUFFER_SIZE (380*4+4)
// 7 secondes à priori, et puissancce de 2

unsigned char reverse(unsigned char b) {
    b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
    b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
    b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
    return b;
}




void dump_frames(CircularBufferContext *recording_buf_ctx) {
    int dump_index = 0;
    char filename[256];
    do {
        dump_index++;
        sprintf(filename, "recording_%d", dump_index);
        printf("filename try : %s\n", filename);
    } while(access(filename, FT_OK) == 0);

    FILE *fp = fopen(filename, "w");
    if(!fp) {
        printf("ERROR: Impossible to open %s\n", filename);
        exit(-1);
    }
    printf("Dumping records at %s ...\n", filename);
    unsigned char val[RECORDING_BUFFER_SIZE];
    while(CircularBufferPopFront(recording_buf_ctx, &val) != -1) {
        fwrite(val, sizeof(unsigned char)*RECORDING_BUFFER_SIZE, 1, fp);
    }
    printf("Recording created at %s ...\n", filename);
}


typedef struct sonar_protocol_context {
    FT_HANDLE handle;
    UCHAR acBuf[NUM_BUFFERS][BUFFER_SIZE];
    ULONG ulBytesTransferred[NUM_BUFFERS];
    OVERLAPPED vOverlapped[NUM_BUFFERS];
    ULONG index_buf;
    ULONG first_idx;
    ULONG n;

    CircularBufferContext recording_buf_ctx;
    char *recording_buf;
    bool reading;
} sonar_protocol_context;

typedef enum player_cmd_t {
    CMD_BACK,
    CMD_STEP,
    CMD_PAUSE
} player_cmd_t;


int init_sonar_protocol_ctx(sonar_protocol_context *ctx, bool reading) {
    ctx->reading = reading;
    ctx->index_buf = 0;
    ctx->recording_buf = (unsigned char*) malloc(RECORDING_BUFFER_LEN * sizeof(unsigned char) * RECORDING_BUFFER_SIZE);
    if(reading) {
        return 0;
    }
    CircularBufferInit( &ctx->recording_buf_ctx, ctx->recording_buf, RECORDING_BUFFER_LEN*RECORDING_BUFFER_SIZE, sizeof(unsigned char)*RECORDING_BUFFER_SIZE);

    FT_Create(0, FT_OPEN_BY_INDEX, &ctx->handle);
    if(!ctx->handle) {
        printf("Failed to create FTDI device\n");
        return -1;
    }
    printf("FTDI Device created \n");
    FT_SetPipeTimeout(ctx->handle, 0x02, 0); // WTF ?
    FT_SetPipeTimeout(ctx->handle, 0x82, 0); // WTF ?

    for (int i=0; i<NUM_BUFFERS; i++) {
        if(FT_OK != FT_InitializeOverlapped(ctx->handle, &ctx->vOverlapped[i]))
            printf("FTDI failed to init\n");
    }

    if(FT_OK != FT_SetStreamPipe(ctx->handle, FALSE, FALSE, 0x82, BUFFER_SIZE))
        printf("FTDI failed to set stream\n");

    // Queue up the initial batch of requests
    for (int i=0; i<NUM_BUFFERS; i++) {
        if(FT_OK != FT_ReadPipeEx(ctx->handle, FIFO_CHANNEL_1, &ctx->acBuf[i][0], BUFFER_SIZE, &ctx->ulBytesTransferred[i], &ctx->vOverlapped[i]))
            printf("FTDI failed to read\n");
    }

}

void get_frames_from_disk(sonar_protocol_context *ctx, char *filename) {
    FILE *fp = fopen(filename, "r");
    if(!fp) {
        printf("ERROR: Impossible to open %s\n", filename);
        exit(-1);
    }
    size_t n = fread(ctx->recording_buf, sizeof(unsigned char)*RECORDING_BUFFER_SIZE, RECORDING_BUFFER_LEN, fp); ctx->reading = true;
    printf("frames got = %d\n", n);
}




int get_sonar_frame(sonar_protocol_context *ctx, fftw_complex *signal_3d, player_cmd_t cmd) {

    while(true) {
        unsigned char *octets;
        if(ctx->reading) {
            ctx->n = RECORDING_BUFFER_SIZE;
            octets = &ctx->recording_buf[RECORDING_BUFFER_SIZE*ctx->index_buf];
            ctx->first_idx = 0;

            if (++ctx->index_buf == RECORDING_BUFFER_LEN) {
                ctx->index_buf = 0;
            }
        } else {
            octets = &ctx->acBuf[ctx->index_buf][0];
        }

        if(octets[ctx->first_idx] != 0 || octets[ctx->first_idx+1] != 0) {
            printf("WRONG beginning n=%d\n", ctx->n);
        }
        while(octets[ctx->first_idx] == 0 && octets[ctx->first_idx+1] == 0 && ctx->n >= NUM_CHANNELS*2+4+ctx->first_idx)  {

            signed short line[NUM_CHANNELS];
            unsigned char channel_number_lsb = reverse(octets[ctx->first_idx + 3]);
            unsigned char channel_number_msb = reverse(octets[ctx->first_idx + 2]);
            unsigned short channel_number = ((channel_number_msb << 8) | channel_number_lsb);
            //printf("-------------------------------------\t%d\t%d\t%d\t%d\t%d\n", ctx->first_idx, ctx->n, sizeof(octets), channel_number, ctx->index_buf);
            if(!ctx->reading) {
                if(CircularBufferSpace(&ctx->recording_buf_ctx) == 0) {

                    unsigned char val[RECORDING_BUFFER_SIZE];
                    CircularBufferPopFront(&ctx->recording_buf_ctx, &val);
                }
                CircularBufferPushBack(&ctx->recording_buf_ctx, &octets[ctx->first_idx]);
            }


            for(int j = 0 ; j < NUM_CHANNELS; j++) {
                unsigned char msb = reverse(octets[ctx->first_idx + j*2+4]);
                unsigned char lsb = reverse(octets[ctx->first_idx + j*2+5]);
                signed short value = ((msb << 8) | lsb);
                line[j] = value;
            }
            ctx->first_idx += (NUM_CHANNELS)*2+4;
            float complex z0 = line[0] + line[1] * I;
            for(int j = 0 ; j < NUM_CHANNELS/2 ; j++) {
                int x = 20-j/20;
                int y = j%20;
                float complex z2 = line[j*2+0] + line[j*2+1] * I;
                signal_3d[y+20*x+20*20*(channel_number%L)] = z2;
            }
            if(channel_number%L == L-1) {
             //   printf("idx_buf = %d\n", ctx-> index_buf);
                if(cmd == CMD_BACK)  {
                    ctx->index_buf -= L*2;
              //      printf("BACK\n");
                }
                if(cmd == CMD_PAUSE) {
                    ctx->index_buf -= L;
               //     printf("PAUSE\n");
                }
                if(cmd == CMD_STEP) {
                }
                return 0;
            }
        }

        if(octets[ctx->first_idx] != 0 || octets[ctx->first_idx+1] != 0) {
            printf("out because of bad beggining n=%d\n", ctx->n);
        }

        if(!ctx->reading) {
            //printf("reading here\n");
            if(FT_OK != FT_GetOverlappedResult(
                        ctx->handle,
                        &ctx->vOverlapped[ctx->index_buf],
                        &ctx->ulBytesTransferred[ctx->index_buf],
                        TRUE))

                printf("failed to get overlapped result \n");
            // Re-submit to keep request full
            int err = FT_ReadPipeEx(ctx->handle,
                    FIFO_CHANNEL_1,
                    &ctx->acBuf[ctx->index_buf][0],
                    BUFFER_SIZE,
                    &ctx->ulBytesTransferred[ctx->index_buf],
                    &ctx->vOverlapped[ctx->index_buf]);

            if(err != FT_OK) {
                printf("failed to read pipe\n");
                exit(-1);
            }

            // Re-submit to keep request full
            // Roll-over
            if (++ctx->index_buf == NUM_BUFFERS) {
                ctx->index_buf = 0;
            }

            octets = &ctx->acBuf[ctx->index_buf][0];
            ctx->n = ctx->ulBytesTransferred[ctx->index_buf];
            ctx->first_idx = 0;


        }
    }
}

#endif
