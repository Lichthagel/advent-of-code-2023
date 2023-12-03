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

# Sum part numbers
function hasneighbor((i, j, k)::Tuple{Int64,Int64,Int64}, f::Function)::Bool
  # Line above
  if i > 1
    for p in max(1, j - 1):min(length(grid[i]), k + 1)
      if f(i - 1, p)
        return true
      end
    end
  end

  # Same line
  if j > 1 && f(i, j - 1)
    return true
  end

  if k < length(grid[i]) && f(i, k + 1)
    return true
  end

  # Line below
  if i < length(grid)
    for p in max(1, j - 1):min(length(grid[i]), k + 1)
      if f(i + 1, p)
        return true
      end
    end
  end

  return false
end

function ispartnumber((i, j, k)::Tuple{Int64,Int64,Int64})::Bool
  function issysmbol(c::Char)
    return !isdigit(c) && c != '.'
  end

  return hasneighbor((i, j, k), (x, y) -> issysmbol(grid[x][y]))
end

partNumbers = filter(ispartnumber, numbers)

# part1 = 
# numbers |>
# filter(ispartnumber) |> 
# map(x -> parse(Int64, join(grid[x[1]][x[2]:x[3]]))) |> 
# sum

part1 = sum(map(x -> parse(Int64, join(grid[x[1]][x[2]:x[3]])), partNumbers))

println(part1)

potentialGears::Vector{Tuple{Int64,Int64}} = []

for (i, line) in enumerate(grid)
  for (j, c) in enumerate(line)
    if c == '*'
      push!(potentialGears, (i, j))
    end
  end
end

function gearRatio((p, q)::Tuple{Int64,Int64})::Int64
  ratio::Int64 = 1
  connectedPartNumbers::Int64 = 0

  for (i, j, k) in partNumbers
    if hasneighbor((i, j, k), (x, y) -> (x, y) == (p, q))
      ratio *= parse(Int64, join(grid[i][j:k]))
      connectedPartNumbers += 1
    end
  end

  # println("Found gear at $(p), $(q) with ratio $(ratio) and $(connectedPartNumbers) connected part numbers")

  if connectedPartNumbers == 2
    return ratio
  else
    return 0
  end
end

part2 = potentialGears .|> gearRatio |> sum

println(part2)