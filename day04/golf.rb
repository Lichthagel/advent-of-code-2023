require 'set'

s = File.read("input.txt").split("\n")

x = 0
m = [1] * s.length

for i in (0..(s.length-1))
  e = s[i].split(": ")[1].split(" | ").map { |e| e.split(" ").map(&:to_i).to_set }
  c = (e[0] & e[1]).length
  x += c > 0 ? 2 ** (c - 1) : 0

  for j in (1..c)
    m[i + j] += m[i]
  end
  
end

puts x, m.sum
