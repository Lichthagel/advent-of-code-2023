#!/usr/bin/env python3

import sys
from enum import Enum
from typing import cast

if len(sys.argv) != 2:
    print("Please specify an input file")
    sys.exit(1)

with open(sys.argv[1], "r", encoding="utf8") as file:
    data = file.read().rstrip().split("\n")


class Direction(Enum):
    UP = 0
    RIGHT = 1
    DOWN = 2
    LEFT = 3

    def advance(self, x_coord: int, y_coord: int) -> tuple[int, int]:
        if self == Direction.UP:
            return x_coord - 1, y_coord
        if self == Direction.RIGHT:
            return x_coord, y_coord + 1
        if self == Direction.DOWN:
            return x_coord + 1, y_coord
        if self == Direction.LEFT:
            return x_coord, y_coord - 1

        raise ValueError("Invalid direction")


class MirrorGrid:
    def __init__(self, input_data: list[str]) -> None:
        self.grid = input_data

    def __getitem__(self, key: tuple[int, int]) -> str:
        x, y = key
        return self.grid[x][y]

    def __setitem__(self, key: tuple[int, int], value: str) -> None:
        x, y = key
        self.grid[x] = self.grid[x][:y] + value + self.grid[x][y + 1 :]

    def __str__(self) -> str:
        return "\n".join(self.grid)

    def __repr__(self) -> str:
        return str(self)

    def energized(self, initial_beam: tuple[tuple[int, int], Direction]) -> int:
        beams: list[tuple[tuple[int, int], Direction]] = [initial_beam]
        status: list[list[tuple[bool, bool, bool, bool]]] = [
            [(False, False, False, False) for _ in range(len(data[0]))]
            for _ in range(len(data))
        ]

        while len(beams) > 0:
            (x, y), direction = beams.pop(0)

            if x < 0 or y < 0 or x >= len(data) or y >= len(data[0]):
                continue

            char = data[x][y]
            curr_status = list(status[x][y])

            if curr_status[direction.value]:
                continue
            else:
                curr_status[direction.value] = True
                status[x][y] = cast(tuple[bool, bool, bool, bool], tuple(curr_status))

            if char == "/":
                if direction == Direction.RIGHT:
                    direction = Direction.UP
                elif direction == Direction.DOWN:
                    direction = Direction.LEFT
                elif direction == Direction.LEFT:
                    direction = Direction.DOWN
                elif direction == Direction.UP:
                    direction = Direction.RIGHT

                beams.append((direction.advance(x, y), direction))
            elif char == "\\":
                if direction == Direction.RIGHT:
                    direction = Direction.DOWN
                elif direction == Direction.DOWN:
                    direction = Direction.RIGHT
                elif direction == Direction.LEFT:
                    direction = Direction.UP
                elif direction == Direction.UP:
                    direction = Direction.LEFT

                beams.append((direction.advance(x, y), direction))
            elif char == "-" and direction in (Direction.UP, Direction.DOWN):
                beams.append((Direction.LEFT.advance(x, y), Direction.LEFT))
                beams.append((Direction.RIGHT.advance(x, y), Direction.RIGHT))
            elif char == "|" and direction in (Direction.LEFT, Direction.RIGHT):
                beams.append((Direction.UP.advance(x, y), Direction.UP))
                beams.append((Direction.DOWN.advance(x, y), Direction.DOWN))
            else:
                beams.append((direction.advance(x, y), direction))

        count_energized = sum(sum(1 for status in row if any(status)) for row in status)

        return count_energized

    def max_energized(self) -> int:
        max_energized = 0

        # LEFT & RIGHT
        for x in range(len(data)):
            max_energized = (
                max_energized
                if max_energized > self.energized(((x, 0), Direction.RIGHT))
                else self.energized(((x, 0), Direction.RIGHT))
            )
            max_energized = (
                max_energized
                if max_energized
                > self.energized(((x, len(data[0]) - 1), Direction.LEFT))
                else self.energized(((x, len(data[0]) - 1), Direction.LEFT))
            )

        # UP & DOWN
        for y in range(len(data[0])):
            max_energized = (
                max_energized
                if max_energized > self.energized(((0, y), Direction.DOWN))
                else self.energized(((0, y), Direction.DOWN))
            )
            max_energized = (
                max_energized
                if max_energized > self.energized(((len(data) - 1, y), Direction.UP))
                else self.energized(((len(data) - 1, y), Direction.UP))
            )

        return max_energized


grid = MirrorGrid(data)

print(grid.energized(((0, 0), Direction.RIGHT)))

print(grid.max_energized())
