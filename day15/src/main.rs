use std::collections::HashMap;

fn hash(s: &str) -> usize {
    let mut current_value = 0;

    for c in s.chars() {
        current_value += c as usize;
        current_value *= 17;
        current_value %= 256;
    }

    current_value
}

fn main() -> Result<(), &'static str> {
    let args = std::env::args();

    if args.len() != 2 {
        return Err("Please specify an input file");
    }

    let input = std::fs::read_to_string(args.skip(1).next().unwrap()).unwrap();

    println!(
        "{}",
        input.trim().split(",").map(|s| hash(s)).sum::<usize>()
    );

    let mut boxes: Vec<Vec<&str>> = Vec::with_capacity(256);
    boxes.resize(256, Vec::new());

    let mut lens_map: HashMap<&str, usize> = HashMap::new();

    for instruction in input.trim().split(",") {
        let (label, val) = instruction.split_once(|ch| ch == '=' || ch == '-').unwrap();

        let box_index = hash(label);

        if val.len() > 0 {
            if !boxes[box_index].contains(&label) {
                boxes[box_index].push(label);
            }

            lens_map.insert(label, val.parse().unwrap());
        } else {
            // remove lens from box
            if let Some(index) = boxes[box_index].iter().position(|&s| s == label) {
                boxes[box_index].remove(index);
            }

            lens_map.remove(label);
        }
    }

    let mut total_focusing_power = 0;

    for (label, focal_length) in lens_map.into_iter() {

        let box_index = hash(label);

        let slot = boxes[box_index].iter().position(|&s| s == label).unwrap();

        total_focusing_power += (box_index + 1) * (slot + 1) * focal_length;
    }

    println!("{}", total_focusing_power);

    Ok(())
}
