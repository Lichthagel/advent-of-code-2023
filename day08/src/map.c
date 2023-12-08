#include "map.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>

map_t map_parse(const char *file)
{
  FILE *fp = fopen(file, "r");

  if (fp == NULL)
  {
    printf("Could not open file %s\n", file);
    exit(1);
  }

  map_t map;

  if (fgets(map.instructions, 1024, fp) == NULL)
  {
    printf("Could not read line\n");
    exit(1);
  }

  map.instruction_count = strlen(map.instructions) - 1;

  map.crossings = crossings_init();
  crossings_parse(&map.crossings, fp);

  fclose(fp);

  return map;
}

void map_free(map_t map)
{
  crossings_free(map.crossings);
}

void map_step(map_t map, position_t position, size_t instruction)
{
  if (map.instructions[instruction % map.instruction_count] == 'L')
  {
    crossings_left(map.crossings, position);
  }
  else
  {
    crossings_right(map.crossings, position);
  }
}

size_t map_step_ZZZ(map_t map, position_t position)
{
  size_t steps = 0;

  while (position_cmp(position, (position_t){'Z', 'Z', 'Z'}) != 0)
  {
    map_step(map, position, steps);
    steps++;
  }

  return steps;
}
