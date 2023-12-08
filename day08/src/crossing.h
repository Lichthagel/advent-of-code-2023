#pragma once

#include <position.h>
#include <stddef.h>
#include <stdio.h>

struct crossing
{
  position_t location;
  position_t left;
  position_t right;
};

typedef struct crossing crossing_t;

void crossing_print(crossing_t crossing);

crossing_t crossing_parse(char *str);

struct crossings
{
  crossing_t *crossings;
  size_t count;
  size_t size;
};

typedef struct crossings crossings_t;

crossings_t crossings_init();

void crossings_free(crossings_t crossings);

void crossings_add(crossings_t *crossings, crossing_t crossing);

void crossings_parse(crossings_t *crossings, FILE *fp);

void crossings_print(crossings_t crossings);

void crossings_left(crossings_t crossings, position_t position);

void crossings_right(crossings_t crossings, position_t position);

void crossings_left_all(crossings_t crossings, positions_t positions);

void crossings_right_all(crossings_t crossings, positions_t positions);
