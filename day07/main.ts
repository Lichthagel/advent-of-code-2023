#!/usr/bin/env -S deno run --allow-read

if (Deno.args.length < 1) {
  console.log("Please specify an input file");
  Deno.exit(1);
}

const lines = (await Deno.readTextFile(Deno.args[0])).trim().split("\n");

const parseHandType = (handRaw: string, part2 = false): number => {
  const chars: Record<string, number> = {};
  handRaw
    .split("")
    .filter((el) => !part2 || el !== "J")
    .forEach((char) => {
      chars[char] = (chars[char] || 0) + 1;
    });

  const charsV = Object.values(chars);

  const jokers = part2
    ? handRaw.split("").filter((el) => el === "J").length
    : 0;

  // FIVE OF A KIND
  if (charsV.some((v) => v + jokers === 5) || jokers === 5) {
    return 6;
  }

  // FOUR OF A KIND
  // equality is sufficient since we already know that there is no 5 of a kind
  if (charsV.some((v) => v + jokers === 4)) {
    return 5;
  }

  // FULL HOUSE
  // with 3 jokers, we can always get at least 4 of a kind
  // with 2 jokers, we either get at least 4 of a kind or cant construct a full house
  // with 1 joker, we need two pairs or we already have four of a kind
  if (jokers === 1 && charsV.filter((v) => v === 2).length === 2) {
    return 4;
  }

  if (charsV.some((v) => v === 3) && charsV.some((v) => v === 2)) {
    return 4;
  }

  // THREE OF A KIND
  if (charsV.some((v) => v + jokers === 3)) {
    return 3;
  }

  // TWO PAIRS
  if (charsV.filter((v) => v === 2).length === 2) {
    return 2;
  }

  // ONE PAIR
  if (charsV.some((v) => v + jokers === 2)) {
    return 1;
  }

  return 0;
};

const parseHand = (handRaw: string, part2 = false) => {
  const cardValue = handRaw.split("").map((char) => {
    switch (char) {
      case "A":
        return 14;
      case "K":
        return 13;
      case "Q":
        return 12;
      case "J":
        return part2 ? 1 : 11;
      case "T":
        return 10;
      default:
        return parseInt(char);
    }
  });

  return {
    typeValue: parseHandType(handRaw, part2),
    cardValue,
  };
};

const parseHands = (lines: string[], part2 = false) => {
  return lines.map((line) => {
    const split = line.split(" ");

    return {
      ...parseHand(split[0], part2),
      bet: parseInt(split[1]),
    };
  });
};

const solve = (part2 = false) => {
  const hands = parseHands(lines, part2);

  hands.sort((a, b) => {
    if (a.typeValue === b.typeValue) {
      for (let i = 0; i < a.cardValue.length; i++) {
        if (a.cardValue[i] === b.cardValue[i]) continue;
        return a.cardValue[i] - b.cardValue[i];
      }
    }

    return a.typeValue - b.typeValue;
  });

  const sum = hands.reduce(
    (acc, hand, index) => acc + hand.bet * (index + 1),
    0
  );

  console.log(sum);
};

solve();
solve(true);
