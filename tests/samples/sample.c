#include <stdio.h>
#define MAX 256
typedef struct point { int x; } point_t;
static const unsigned int limit = 0x80;
static void greet(const char *name, int n) {
    if (name == NULL) return;
    printf("hi %s\n", name);
}
