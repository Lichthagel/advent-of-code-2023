import std/strutils
import std/os

if paramCount() < 1:
  echo "Please specify an input file"
  quit(1)

let input = readFile(paramStr(1))

let lines = input.splitLines()

proc calibrationValue(line: string, part2: bool): int =
  var firstVal: int = 10
  var secondVal: int = 10

  proc setVal(val: int): void =
    if firstVal == 10:
      firstVal = val
    
    secondVal = val

  for i in 0..line.len-1:
    if isDigit(line[i]):
      setVal(line[i].int - '0'.int)

    if part2:

      if i + 2 < line.len:

        if line[i..i+2] == "one":
          setVal(1)

        if line[i..i+2] == "two":
          setVal(2)

        if line[i..i+2] == "six":
          setVal(6)


      if i + 3 < line.len:

        if line[i..i+3] == "zero":
          setVal(0)

        if line[i..i+3] == "four":
          setVal(4)

        if line[i..i+3] == "five":
          setVal(5)

        if line[i..i+3] == "nine":
          setVal(9)

      if i + 4 < line.len:

        if line[i..i+4] == "three":
          setVal(3)

        if line[i..i+4] == "seven":
          setVal(7)

        if line[i..i+4] == "eight":
          setVal(8)
  
  return firstVal * 10 + secondVal

var sumPart1 = 0
var sumPart2 = 0

for line in lines:
  if line.len > 0:
    sumPart1 += calibrationValue(line, false)
    sumPart2 += calibrationValue(line, true)

echo sumPart1
echo sumPart2
