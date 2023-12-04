require 'set'

s = File.read("input.txt").split("\n").map { |l| l.split(": ")[1].split(" | ").map { |e|  e.split(" ").map(&:to_i).to_set } }.map { |e| (e[0] & e[1]).length }

puts s.map { |c| c > 0 ? 2 ** (c - 1) : 0 }.sum

m = [1] * s.length

for i in (0..(s.length-1))
  for j in (1..s[i])
    m[i + j] += m[i]
  end
end

puts m.sum