s = File.read("input.txt").split("\n")

x = 0
m = s.map { 1 }

for i in 0..s.count-1
  a, b = s[i].split(": ")[1].split(" | ").map { |e| e.split.map(&:to_i) }
  c = (a & b).count
  x += c > 0 ? 2 ** (c - 1) : 0

  for j in 1..c
    m[i + j] += m[i]
  end
  
end

puts x, m.sum
