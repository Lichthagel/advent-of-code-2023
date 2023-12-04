#!/usr/bin/env ruby

if ARGV.length != 1
  raise "Please specify an input file"
end

input = File.read(ARGV[0]).split("\n")

sum = 0

cards = input.map { |line| line.split(": ")[1].split(" | ").map { |card| card.split(" ").map(&:to_i) } }

def card_count(card)
  count = 0
  for num in card[1]
    count += 1 if card[0].include?(num)
  end

  count
end

for card in cards
  count = card_count(card)

  if count > 0
    sum += 2 ** (count - 1)
  end
end

puts sum

my_cards = [1] * cards.length

for i in 0..cards.length - 1
  card = cards[i]
  count = card_count(card)

  if count > 0
    for j in 1..count
      my_cards[i + j] += my_cards[i]
    end
  end
end

puts my_cards.sum

