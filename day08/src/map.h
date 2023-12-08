#include <crossing.h>

struct map
{
  char instructions[1024];
  size_t instruction_count;
  crossings_t crossings;
};

typedef struct map map_t;

map_t map_parse(const char *file);

void map_free(map_t map);

void map_step(map_t map, position_t position, size_t instruction);

size_t map_step_ZZZ(map_t map, position_t position);