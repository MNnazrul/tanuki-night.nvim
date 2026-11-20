#include <stdint.h>
#include <stdlib.h>

#define RING_CAP 64

typedef struct {
    uint8_t data[RING_CAP];
    size_t head, tail;
} ring_t;

/* Push one byte; returns 0 when the buffer is full. */
static inline int ring_push(ring_t *r, uint8_t byte) {
    size_t next = (r->head + 1) % RING_CAP;
    if (next == r->tail)
        return 0;
    r->data[r->head] = byte;
    r->head = next;
    return 1;
}
