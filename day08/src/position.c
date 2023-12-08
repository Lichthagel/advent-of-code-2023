#include <position.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void position_copy(position_t destination, position_t source)
{
  for (size_t i = 0; i < POSITION_SIZE; i++)
  {
    destination[i] = source[i];
  }
}

int position_cmp(position_t position, position_t other)
{
  return strncmp(position, other, POSITION_SIZE);
}

positions_t positions_init()
{
  positions_t positions;

  positions.count = 0;
  positions.size = 10;
  positions.positions = malloc(sizeof(char) * positions.size * POSITION_SIZE);

  return positions;
}

void positions_free(positions_t positions)
{
  free(positions.positions);
}

void positions_add(positions_t *positions, position_t position)
{
  if (positions->count == positions->size)
  {
    positions->size += 10;
    positions->positions = realloc(positions->positions, sizeof(char) * positions->size * POSITION_SIZE);
  }

  position_copy(positions->positions + (positions->count * POSITION_SIZE), position);
  positions->count++;
}

void positions_print(positions_t positions)
{
  printf("Positions: ");

  for (size_t i = 0; i < positions.count; i++)
  {
    printf("%.3s ", positions.positions + (i * POSITION_SIZE));
  }

  printf("\n");
}
