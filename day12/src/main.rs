use std::fmt::Display;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Condition {
    Operational,
    Damaged,
    Unknown,
}

impl From<char> for Condition {
    fn from(value: char) -> Self {
        match value {
            '.' => Condition::Operational,
            '#' => Condition::Damaged,
            _ => Condition::Unknown,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct SpringsRow {
    conditions: Vec<Condition>,
    groups: Vec<usize>,
}

impl From<&str> for SpringsRow {
    fn from(value: &str) -> Self {
        let (conditions_str, groups_str) = value.split_once(" ").unwrap();

        let conditions = conditions_str.chars().map(|c| c.into()).collect();
        let groups = groups_str
            .split(",")
            .map(|group| group.parse::<usize>().unwrap())
            .collect();

        Self { conditions, groups }
    }
}

impl Display for SpringsRow {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for condition in &self.conditions {
            match condition {
                Condition::Operational => write!(f, ".")?,
                Condition::Damaged => write!(f, "#")?,
                Condition::Unknown => write!(f, "?")?,
            }
        }

        write!(f, " ")?;

        for group in &self.groups {
            write!(f, "{},", group)?;
        }

        Ok(())
    }
}

impl SpringsRow {
    fn arrangements(&self) -> usize {
        self._arrangements(0, 0, 0)
    }

    fn _arrangements(&self, curr: usize, condition_index: usize, group_index: usize) -> usize {
        if condition_index == self.conditions.len() {
            if group_index >= self.groups.len() {
                if curr == 0 {
                    return 1;
                } else {
                    return 0;
                }
            } else if group_index == self.groups.len() - 1 {
                let group = self.groups[group_index];

                if curr == group {
                    return 1;
                } else {
                    return 0;
                }
            } else {
                return 0;
            }
        }

        let mut arrangements = 0;

        let condition = self.conditions[condition_index];

        if condition == Condition::Operational || condition == Condition::Unknown {
            if curr == 0 {
                arrangements += self._arrangements(0, condition_index + 1, group_index);
            } else {
                let group = self.groups.get(group_index).copied().unwrap_or(0);

                if curr == group {
                    arrangements += self._arrangements(0, condition_index + 1, group_index + 1);
                }
            }
        }

        if condition == Condition::Damaged || condition == Condition::Unknown {
            arrangements += self._arrangements(curr + 1, condition_index + 1, group_index);
        }

        arrangements
    }
}

fn main() -> Result<(), &'static str> {
    let args = std::env::args();

    if args.len() != 2 {
        return Err("Please specify an input file");
    }

    let input = std::fs::read_to_string(args.skip(1).next().unwrap()).unwrap();

    let rows: Vec<SpringsRow> = input.lines().map(SpringsRow::from).collect();

    println!("{}", rows.iter().map(|r| r.arrangements()).sum::<usize>());

    Ok(())
}
