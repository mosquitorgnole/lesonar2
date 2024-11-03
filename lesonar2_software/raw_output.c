#include <stdlib.h>
#include <stdint.h>
#include <complex.h>
#include <stdbool.h>
#include "ftd3xx.h"


#include <stdio.h>
#include <string.h>

// Linux headers
#include <fftw3.h>


#include "colormap.h"

#define NUM_CHANNELS (380*2)
#define BUFFER_SIZE (382*4*512)

#define FIFO_CHANNEL_1	0
#define TIMEOUT			0 //0xFFFFFFFF

#define NUM_BUFFERS 8


int main(int argc, unsigned char **argv) {
    FT_HANDLE handle = NULL;
    FT_Create(0, FT_OPEN_BY_INDEX, &handle);
    if(!handle) {
        printf("Failed to create FTDI device\n");
        return -1;
    }
    printf("FTDI Device created \n");

    FT_SetPipeTimeout(handle, 0x02, 0); // WTF ?
    FT_SetPipeTimeout(handle, 0x82, 0); // WTF ?

    UCHAR acBuf[NUM_BUFFERS][BUFFER_SIZE] = {0xFF};
    ULONG ulBytesTransferred[NUM_BUFFERS];
    OVERLAPPED vOverlapped[NUM_BUFFERS] = {0};
    for (int i=0; i<NUM_BUFFERS; i++) {
        if(FT_OK != FT_InitializeOverlapped(handle, &vOverlapped[i]))
            printf("FTDI failed to init\n");
    }
    if(FT_OK != FT_SetStreamPipe(handle, FALSE, FALSE, 0x82, BUFFER_SIZE))
        printf("FTDI failed to set stream\n");



    // Queue up the initial batch of requests
    for (int i=0; i<NUM_BUFFERS; i++) {
        if(FT_OK != FT_ReadPipeEx(handle, FIFO_CHANNEL_1, &acBuf[i][0], BUFFER_SIZE, &ulBytesTransferred[i], &vOverlapped[i]))
            printf("FTDI failed to read\n");
    }

    FILE *fp;
    if(argc > 1) {
        printf("Preparing recording at %s\n....", argv[1]);
        fp = fopen(argv[1], "w");
    } else {
        printf("Need a file path!!");
        exit(-1);
    }
    int index_buf = 0;

    long total_bytes = 0;
    long max_bytes   = 380*500000; // 500 ms à 4.5e6 Hz

    while(total_bytes < max_bytes) {
        printf(".\n");
        // Wait for transfer to finish
        if(FT_OK != FT_GetOverlappedResult(handle, &vOverlapped[index_buf], &ulBytesTransferred[index_buf], TRUE))
            printf("failed to get overlapped result \n");
        // Re-submit to keep request full
        if(FT_OK != FT_ReadPipeEx(handle, FIFO_CHANNEL_1, &acBuf[index_buf][0], BUFFER_SIZE, &ulBytesTransferred[index_buf], &vOverlapped[index_buf])) {
            printf("failed to read pipe\n");
            exit(-1);
        }
        // Re-submit to keep request full
        // Roll-over
        if (++index_buf == NUM_BUFFERS) {
            index_buf = 0;
        }

        fwrite(&acBuf[index_buf][0], sizeof(unsigned short), ulBytesTransferred[index_buf], fp);
        total_bytes += ulBytesTransferred[index_buf];
    }
    if(fp) {
        fclose(fp);
    }
    return 0;

}
