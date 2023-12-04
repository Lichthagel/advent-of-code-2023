#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  raise "Please specify an input file"
end

input = File.read(ARGV[0]).split("\n")

cards = input.map { |line| line.split(": ")[1].split(" | ").map { |card|  card.split(" ").map(&:to_i).to_set } }
counts = cards.map { |card| (card[0] & card[1]).length }

puts counts.map { |count| count > 0 ? 2 ** (count - 1) : 0 }.sum

my_cards = [1] * cards.length

for i in 0..cards.length - 1
  card = cards[i]
  count = counts[i]

  if count > 0
    for j in 1..count
      my_cards[i + j] += my_cards[i]
    end
  end
end

puts my_cards.sum

