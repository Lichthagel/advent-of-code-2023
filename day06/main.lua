#!/usr/bin/env lua

if #arg < 1 then
  print("Please specify an input file")
  os.exit(1)
end

local input = io.open(arg[1]):read("*a")

local lines = input:gmatch("[^\n]+")

local times_matches = lines():gmatch("%d+")
local distances_matches = lines():gmatch("%d+")

local times = {}
local distances = {}

for time_str in times_matches do
  table.insert(times, time_str)
end

for distance_str in distances_matches do
  table.insert(distances, distance_str)
end

local result = 1;

EPSILON = 0.0000001

local function ways_to_beat(time, distance)
  local discriminant = math.sqrt((time^2 / 4) - distance)

  local x1 = (time / 2) - discriminant
  local x2 = (time / 2) + discriminant

  local min = math.ceil(x1 + EPSILON)
  local max = math.floor(x2 - EPSILON)

  return max - min + 1
end

for i = 1, #times do
  local time = tonumber(times[i])
  local distance = tonumber(distances[i])

  result = result * ways_to_beat(time, distance)
end

print(result)

local total_time = ""
local total_distance = ""

for i = 1, #times do
  total_time = total_time .. times[i]
  total_distance = total_distance .. distances[i]
end

print(ways_to_beat(tonumber(total_time), tonumber(total_distance)))
