#include <crossing.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

void crossing_print(crossing_t crossing)
{
  assert(POSITION_SIZE == 3);

  printf("Crossing: %.3s %.3s %.3s\n", crossing.location, crossing.left, crossing.right);
}

crossing_t crossing_parse(char *str)
{
  assert(strlen(str) == 8 + (3 * POSITION_SIZE));

  crossing_t crossing;

  position_copy(crossing.location, str);
  position_copy(crossing.left, str + POSITION_SIZE + 4);
  position_copy(crossing.right, str + (2 * POSITION_SIZE) + 6);

  return crossing;
}

crossings_t crossings_init()
{
  crossings_t crossings;

  crossings.count = 0;
  crossings.size = 10;
  crossings.crossings = malloc(sizeof(crossing_t) * crossings.size);

  return crossings;
}

void crossings_free(crossings_t crossings)
{
  free(crossings.crossings);
}

void crossings_add(crossings_t *crossings, crossing_t crossing)
{
  if (crossings->count == crossings->size)
  {
    crossings->size += 10;
    crossings->crossings = realloc(crossings->crossings, sizeof(crossing_t) * crossings->size);
  }

  crossings->crossings[crossings->count] = crossing;
  crossings->count++;
}

void crossings_parse(crossings_t *crossings, FILE *fp)
{
  char str[256];

  // skip 1 line
  if (fgets(str, 256, fp) == NULL)
  {
    printf("Could not read line\n");
    exit(1);
  }

  while (fgets(str, 256, fp) != NULL)
  {
    crossing_t crossing = crossing_parse(str);
    crossings_add(crossings, crossing);
  }
}

void crossings_print(crossings_t crossings)
{
  for (size_t i = 0; i < crossings.count; i++)
  {
    crossing_print(crossings.crossings[i]);
  }
}

void crossings_left(crossings_t crossings, position_t position)
{
  for (size_t i = 0; i < crossings.count; i++)
  {
    if (position_cmp(crossings.crossings[i].location, position) == 0)
    {
      position_copy(position, crossings.crossings[i].left);
      break;
    }
  }
}

void crossings_right(crossings_t crossings, position_t position)
{
  for (size_t i = 0; i < crossings.count; i++)
  {
    if (position_cmp(crossings.crossings[i].location, position) == 0)
    {
      position_copy(position, crossings.crossings[i].right);
      break;
    }
  }
}

void crossings_left_all(crossings_t crossings, positions_t positions)
{
  for (size_t i = 0; i < positions.count; i++)
  {
    for (size_t j = 0; j < crossings.count; j++)
    {
      if (position_cmp(crossings.crossings[j].location, positions.positions + (i * POSITION_SIZE)) == 0)
      {
        position_copy(positions.positions + (i * POSITION_SIZE), crossings.crossings[j].left);
        break;
      }
    }
  }
}

void crossings_right_all(crossings_t crossings, positions_t positions)
{
  for (size_t i = 0; i < positions.count; i++)
  {
    for (size_t j = 0; j < crossings.count; j++)
    {
      if (position_cmp(crossings.crossings[j].location, positions.positions + (i * POSITION_SIZE)) == 0)
      {
        position_copy(positions.positions + (i * POSITION_SIZE), crossings.crossings[j].right);
        break;
      }
    }
  }
}