use std::ops::RangeInclusive;

use nom::{
    bytes::complete::tag,
    character::complete::multispace0,
    multi::{self, separated_list1},
    IResult,
};

#[derive(Debug)]
struct Seeds {
    seeds1: Vec<u64>,
    seeds2: Vec<RangeInclusive<u64>>,
}

impl Seeds {
    fn parse(input: &str) -> IResult<&str, Seeds> {
        let (input, _) = tag("seeds: ")(input)?;
        let (input, nums) = separated_list1(tag(" "), nom::character::complete::u64)(input)?;

        let seeds1 = nums.clone();
        let seeds2 = nums.chunks(2).map(|e| e[0]..=(e[0] + e[1] - 1)).collect();

        let (input, _) = multispace0(input)?;

        Ok((input, Seeds { seeds1, seeds2 }))
    }
}

#[derive(Debug)]
struct Mapping {
    src_range: RangeInclusive<u64>,
    dest_start: u64,
}

impl Mapping {
    fn parse(input: &str) -> IResult<&str, Mapping> {
        let (input, (dest_start, _, src_start, _, length, _)) = nom::sequence::tuple((
            nom::character::complete::u64,
            tag(" "),
            nom::character::complete::u64,
            tag(" "),
            nom::character::complete::u64,
            multispace0,
        ))(input)?;

        Ok((
            input,
            Mapping {
                src_range: src_start..=(src_start + length - 1),
                dest_start,
            },
        ))
    }
}

type Map = Vec<Mapping>;

fn parse_map(input: &str) -> IResult<&str, Map> {
    let (input, mappings) = multi::many0(Mapping::parse)(input)?;

    Ok((input, mappings))
}

#[derive(Debug)]
struct Garden {
    seeds: Seeds,

    seed_to_soil: Map,
    soil_to_fertilizer: Map,
    fertilizer_to_water: Map,
    water_to_light: Map,
    light_to_temperature: Map,
    temperature_to_humidity: Map,
    humidity_to_location: Map,
}

impl Garden {
    fn parse(input: &str) -> IResult<&str, Garden> {
        let (input, seeds) = Seeds::parse(input)?;

        let (input, _) = tag("seed-to-soil map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, seed_to_soil) = parse_map(input)?;

        let (input, _) = tag("soil-to-fertilizer map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, soil_to_fertilizer) = parse_map(input)?;

        let (input, _) = tag("fertilizer-to-water map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, fertilizer_to_water) = parse_map(input)?;

        let (input, _) = tag("water-to-light map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, water_to_light) = parse_map(input)?;

        let (input, _) = tag("light-to-temperature map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, light_to_temperature) = parse_map(input)?;

        let (input, _) = tag("temperature-to-humidity map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, temperature_to_humidity) = parse_map(input)?;

        let (input, _) = tag("humidity-to-location map:")(input)?;
        let (input, _) = multispace0(input)?;
        let (input, humidity_to_location) = parse_map(input)?;

        Ok((
            input,
            Garden {
                seeds,
                seed_to_soil,
                soil_to_fertilizer,
                fertilizer_to_water,
                water_to_light,
                light_to_temperature,
                temperature_to_humidity,
                humidity_to_location,
            },
        ))
    }
}

fn map(input: &[u64], map: &Map) -> Vec<u64> {
    let mut output = Vec::from(input);

    for i in 0..input.len() {
        let input_val = input[i];

        for mapping in map {
            if mapping.src_range.contains(&input_val) {
                let dest_val = input_val - mapping.src_range.start() + mapping.dest_start;
                output[i] = dest_val;
                break;
            }
        }
    }

    output
}

fn solve_part1(garden: &Garden) -> u64 {
    let mut locs = garden.seeds.seeds1.clone();

    locs = map(&locs, &garden.seed_to_soil);
    locs = map(&locs, &garden.soil_to_fertilizer);
    locs = map(&locs, &garden.fertilizer_to_water);
    locs = map(&locs, &garden.water_to_light);
    locs = map(&locs, &garden.light_to_temperature);
    locs = map(&locs, &garden.temperature_to_humidity);
    locs = map(&locs, &garden.humidity_to_location);

    locs.into_iter().min().unwrap()
}

// fn intersect(a: &RangeInclusive<u64>, b: &RangeInclusive<u64>) -> bool {
//     a.contains(b.start()) || a.contains(b.end()) || b.contains(a.start()) || b.contains(a.end())
// }

fn map_range(input: &[RangeInclusive<u64>], map: &Map) -> Vec<RangeInclusive<u64>> {
    let mut unmapped = input.to_vec();
    let mut output = Vec::new();

    for mapping in map {
        let mut new_unmapped = Vec::new();

        for range in unmapped.into_iter() {
            let intersection_start = mapping.src_range.start().max(range.start());
            let intersection_end = mapping.src_range.end().min(range.end());

            if intersection_start <= intersection_end {
                output.push(
                    mapping.dest_start + intersection_start - mapping.src_range.start()
                        ..=mapping.dest_start + intersection_end - mapping.src_range.start(),
                );

                if range.start() < intersection_start {
                    new_unmapped.push(*range.start()..=intersection_start - 1);
                }

                if intersection_end < range.end() {
                    new_unmapped.push(intersection_end + 1..=*range.end());
                }
            } else {
                new_unmapped.push(range);
            }
        }

        unmapped = new_unmapped;
    }

    output.extend(unmapped);

    output
}

fn solve_part2(garden: &Garden) -> u64 {
    let mut locs = garden.seeds.seeds2.clone();

    locs = map_range(&locs, &garden.seed_to_soil);
    locs = map_range(&locs, &garden.soil_to_fertilizer);
    locs = map_range(&locs, &garden.fertilizer_to_water);
    locs = map_range(&locs, &garden.water_to_light);
    locs = map_range(&locs, &garden.light_to_temperature);
    locs = map_range(&locs, &garden.temperature_to_humidity);
    locs = map_range(&locs, &garden.humidity_to_location);

    locs.into_iter().map(|r| r.into_inner().0).min().unwrap()
}

fn main() -> Result<(), &'static str> {
    let args = std::env::args();

    if args.len() < 2 {
        return Err("Please specify an input file");
    }

    let input_path = args.skip(1).next().unwrap();
    let input_str = std::fs::read_to_string(input_path).unwrap();

    let (_, garden) = Garden::parse(&input_str).unwrap();

    println!("{}", solve_part1(&garden));
    println!("{}", solve_part2(&garden));

    Ok(())
}
