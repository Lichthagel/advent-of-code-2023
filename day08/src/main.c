#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <position.h>
#include <map.h>

void part1(map_t map)
{
  position_t position = {'A', 'A', 'A'};

  printf("%ld\n", map_step_ZZZ(map, position));
}

int main(int argc, char const *argv[])
{
  if (argc < 2)
  {
    printf("Please specify an input file\n");
    return 1;
  }

  map_t map = map_parse(argv[1]);

  part1(map);

  map_free(map);

  return 0;
}
