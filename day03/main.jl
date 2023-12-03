#!/usr/bin/env julia

if length(ARGS) == 0
  println("Please specify an input file")
  exit(1)
end

input = readlines(ARGS[1])

# Two-dimensional array of characters
grid = [collect(line) for line in input]

# Array of found numbers, a tuple of line, start position and end position
numbers::Vector{Tuple{Int64,Int64,Int64}} = []

# Find all numbers in the grid
for (i, line) in enumerate(grid)
  j = 1

  while j <= length(line)
    if isdigit(line[j])
      rest = line[j:end]

      # Find the end of the number
      k = something(findfirst(!isdigit, rest), length(rest) + 1) + j - 2

      # println("Found number $(join(line[j:k])) at line $i, position $j to $k")

      @assert j <= k

      push!(numbers, (i, j, k))

      j = k + 1
    else
      j += 1
    end
  end
end

# Check if a number has a neighboring character that satisfies predicate f
function hasneighbor((i, j, k)::Tuple{Int64,Int64,Int64}, f::Function)::Bool
  # Line above
  if i > 1 && max(1, j - 1):min(length(grid[i]), k + 1) .|> (p -> f(i - 1, p)) |> any
    return true
  end

  # Same line
  if (j > 1 && f(i, j - 1)) || (k < length(grid[i]) && f(i, k + 1))
    return true
  end

  # Line below
  if i < length(grid) && max(1, j - 1):min(length(grid[i]), k + 1) .|> (p -> f(i + 1, p)) |> any
    return true
  end

  return false
end

# Check if a number is a part number
function ispartnumber((i, j, k)::Tuple{Int64,Int64,Int64})::Bool
  function issysmbol(c::Char)
    return !isdigit(c) && c != '.'
  end

  return hasneighbor((i, j, k), (x, y) -> issysmbol(grid[x][y]))
end

partNumbers = filter(ispartnumber, numbers)

part1 = partNumbers .|> (x -> parse(Int64, join(grid[x[1]][x[2]:x[3]]))) |> sum

println(part1)

# Find all potential gears
potentialGears::Vector{Tuple{Int64,Int64}} = []

for (i, line) in enumerate(grid)
  for (j, c) in enumerate(line)
    if c == '*'
      push!(potentialGears, (i, j))
    end
  end
end

# Get the gear ratio of a (potential) gear or 0 if it is not a gear
function gearRatio((p, q)::Tuple{Int64,Int64})::Int64
  foldl((x, y) -> begin
      if hasneighbor(y, (i, j) -> (i, j) == (p, q))
        (x[1] + 1, x[2] * parse(Int64, join(grid[y[1]][y[2]:y[3]])))
      else
        x
      end
    end, partNumbers; init=(0, 1)) |> (x -> begin
    if x[1] == 2
      x[2]
    else
      0
    end
  end)
end

part2 = potentialGears .|> gearRatio |> sum

println(part2)