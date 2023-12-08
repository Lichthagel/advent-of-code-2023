#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <position.h>
#include <map.h>

void part1(map_t map)
{
  position_t position = {'A', 'A', 'A'};

  printf("%ld\n", map_steps_allZ(map, position));
}

size_t gcd(size_t a, size_t b)
{
  if (b == 0)
  {
    return a;
  }

  return gcd(b, a % b);
}

size_t lcm(size_t *nums, size_t count)
{
  size_t result = nums[0];

  for (size_t i = 1; i < count; i++)
  {
    result = (result * nums[i]) / gcd(result, nums[i]);
  }

  return result;
}

void part2(map_t map)
{
  positions_t positions = positions_init();

  for (size_t i = 0; i < map.crossings.count; i++)
  {
    if (map.crossings.crossings[i].location[2] == 'A') 
    {
      positions_add(&positions, map.crossings.crossings[i].location);
    }
    
  }

  size_t *steps = malloc(sizeof(size_t) * positions.count);

  for (size_t i = 0; i < positions.count; i++)
  {
    steps[i] = map_steps_endZ(map, positions_get(positions, i));
  }

  printf("%ld\n", lcm(steps, positions.count));
  
  positions_free(positions);
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

  part2(map);

  map_free(map);

  return 0;
}
