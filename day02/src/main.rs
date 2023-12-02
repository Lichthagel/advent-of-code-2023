fn parse_set(set: &str) -> (u32, u32, u32) {
    let mut split = set.split(&[' ', ',']).filter(|x| !x.is_empty());

    let mut red = 0;
    let mut green = 0;
    let mut blue = 0;

    while let Some(word) = split.next() {
        let num = word.parse::<u32>().unwrap();
        let color = split.next().unwrap();

        match color {
            "red" => red += num,
            "green" => green += num,
            "blue" => blue += num,
            _ => panic!("Unknown color: {}", color),
        }
    }

    return (red, green, blue);
}

fn part1(input: &[&str]) -> u32 {
    input
        .iter()
        .filter_map(|line| {
            let mut game_split = line.split(&[':', ';']);

            let id_raw = game_split.next().unwrap();
            let id = id_raw[5..].parse::<u32>().unwrap();

            while let Some(set) = game_split.next() {
                let (red, green, blue) = parse_set(set);

                if red > 12 || green > 13 || blue > 14 {
                    return None;
                }
            }

            return Some(id);
        })
        .sum()
}

fn part2(input: &[&str]) -> u32 {
    input
        .iter()
        .map(|line| {
            let mut game_split = line.split(&[':', ';']);

            game_split.next();

            let mut min_red = 0;
            let mut min_green = 0;
            let mut min_blue = 0;

            while let Some(set) = game_split.next() {
                let (red, green, blue) = parse_set(set);

                min_red = min_red.max(red);
                min_green = min_green.max(green);
                min_blue = min_blue.max(blue);
            }

            return min_red * min_green * min_blue;
        })
        .sum()
}

fn main() {
    let input: Vec<&str> = include_str!("../input.txt").lines().collect();

    println!("{}", part1(&input));
    println!("{}", part2(&input));

    return;
}
