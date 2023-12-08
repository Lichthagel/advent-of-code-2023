#pragma once

#include <stddef.h>

#define POSITION_SIZE 3lu

typedef char position_t[POSITION_SIZE];

void position_copy(position_t dest, position_t src);

int position_cmp(position_t position, position_t other);

struct positions
{
  char *positions;
  size_t count;
  size_t size;
};

typedef struct positions positions_t;

positions_t positions_init();

void positions_free(positions_t positions);

void positions_add(positions_t *positions, position_t position);

void positions_print(positions_t positions);
