/*
 * MIT License (MIT)
 *
 * Copyright (c) 2019 Kristian Kinderlöv
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/**
 * @addtogroup CIRCULARBUFFER
 * @{
 *
 * @file        circularbuffer.c
 *
 * @brief       A circular buffer implementation.
 *
 * @}
 */

/* **** Includes **** */

#include "circularbuffer.h"

#include <assert.h>
#include <string.h>

/* **** Defines **** */

#define ASSERT(expr) assert(expr)

/* **** Function Definitions **** */

void CircularBufferInit(CircularBufferContext *ctx, void *buf, size_t buf_size,
                        size_t element_size) {
    ASSERT(ctx);
    ASSERT(buf);
    ASSERT(buf_size);
    ASSERT(element_size);

    const size_t size = buf_size / element_size;

    ASSERT((size & (size - 1u)) == 0u);

    ctx->buf = buf;
    ctx->write_pos = 0u;
    ctx->read_pos = 0u;
    ctx->element_size = element_size;
    ctx->max_size = size - 1;
}

void CircularBufferClear(CircularBufferContext *ctx) {
    ASSERT(ctx);

    ctx->write_pos = 0u;
    ctx->read_pos = 0u;
}

int32_t CircularBufferPushBack(CircularBufferContext *ctx, const void *val) {
    ASSERT(ctx);
    ASSERT(val);

    int32_t retval = 0;
    const size_t write_pos = (ctx->write_pos + 1) & ctx->max_size;

    // Check if full
    if (write_pos == ctx->read_pos) {
        goto fail;
    }

    memcpy(&ctx->buf[ctx->write_pos * ctx->element_size], val, ctx->element_size);
    ctx->write_pos = write_pos;

    goto success;

fail:
    retval = -1;
success:
    return retval;
}

int32_t CircularBufferPopFront(CircularBufferContext *ctx, void *val) {
    ASSERT(ctx);
    ASSERT(val);

    int32_t retval = 0;

    // Check if empty
    if (ctx->read_pos == ctx->write_pos) {
        goto fail;
    }

    memcpy(val, &ctx->buf[ctx->read_pos * ctx->element_size], ctx->element_size);
    ctx->read_pos = (ctx->read_pos + 1) & ctx->max_size;

    goto success;

fail:
    retval = -1;
success:
    return retval;
}

int32_t CircularBufferPeek(const CircularBufferContext *ctx, size_t num, void **elem) {
    ASSERT(ctx);

    int32_t retval = 0;
    const size_t write_pos = ctx->write_pos;
    const size_t read_pos = ctx->read_pos;
    const size_t size = ((write_pos - read_pos) & ctx->max_size);

    // Check that the buffer isn't empty and
    // that num is less than number of added elements
    if ((size == 0) || (size <= num)) {
        goto fail;
    }

    const size_t element_pos = ((read_pos + num) & ctx->max_size);
    *elem = &ctx->buf[element_pos * ctx->element_size];

    goto success;

fail:
    retval = -1;
success:
    return retval;
}

size_t CircularBufferSize(const CircularBufferContext *ctx) {
    ASSERT(ctx);

    return ((ctx->write_pos - ctx->read_pos) & ctx->max_size);
}

size_t CircularBufferSpace(const CircularBufferContext *ctx) {
    ASSERT(ctx);

    return (ctx->max_size - CircularBufferSize(ctx));
}

bool CircularBufferEmpty(const CircularBufferContext *ctx) {
    ASSERT(ctx);

    return (ctx->read_pos == ctx->write_pos);
}
