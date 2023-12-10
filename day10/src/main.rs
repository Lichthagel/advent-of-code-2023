use std::ops::{Index, IndexMut};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Direction {
    North,
    South,
    West,
    East,
}

impl Direction {
    fn apply(&self, (x, y): (usize, usize)) -> (usize, usize) {
        match self {
            Direction::North => (x - 1, y),
            Direction::South => (x + 1, y),
            Direction::West => (x, y - 1),
            Direction::East => (x, y + 1),
        }
    }

    fn opposite(&self) -> Self {
        match self {
            Direction::North => Direction::South,
            Direction::South => Direction::North,
            Direction::West => Direction::East,
            Direction::East => Direction::West,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Pipe {
    Horizontal,
    Vertical,
    NorthEast,
    NorthWest,
    SouthWest,
    SouthEast,
    Ground,
}

impl From<char> for Pipe {
    fn from(c: char) -> Self {
        match c {
            '-' => Pipe::Horizontal,
            '|' => Pipe::Vertical,
            'L' => Pipe::NorthEast,
            'J' => Pipe::NorthWest,
            '7' => Pipe::SouthWest,
            'F' => Pipe::SouthEast,
            '.' => Pipe::Ground,
            _ => panic!("Invalid pipe: {}", c),
        }
    }
}

impl From<(bool, bool, bool, bool)> for Pipe {
    fn from((north, south, west, east): (bool, bool, bool, bool)) -> Self {
        if north {
            if south {
                assert!(!west && !east);
                Pipe::Vertical
            } else if west {
                assert!(!east);
                Pipe::NorthWest
            } else if east {
                Pipe::NorthEast
            } else {
                panic!("Invalid pipe")
            }
        } else if south {
            if west {
                assert!(!east);
                Pipe::SouthWest
            } else if east {
                Pipe::SouthEast
            } else {
                panic!("Invalid pipe")
            }
        } else if west {
            if east {
                Pipe::Horizontal
            } else {
                panic!("Invalid pipe")
            }
        } else {
            panic!("Invalid pipe")
        }
    }
}

impl Pipe {
    fn north(&self) -> bool {
        match self {
            Pipe::Vertical => true,
            Pipe::NorthEast => true,
            Pipe::NorthWest => true,
            _ => false,
        }
    }

    fn south(&self) -> bool {
        match self {
            Pipe::Vertical => true,
            Pipe::SouthEast => true,
            Pipe::SouthWest => true,
            _ => false,
        }
    }

    fn east(&self) -> bool {
        match self {
            Pipe::Horizontal => true,
            Pipe::NorthEast => true,
            Pipe::SouthEast => true,
            _ => false,
        }
    }

    fn west(&self) -> bool {
        match self {
            Pipe::Horizontal => true,
            Pipe::NorthWest => true,
            Pipe::SouthWest => true,
            _ => false,
        }
    }

    fn other(&self, direction: Direction) -> Direction {
        match direction {
            Direction::North => {
                assert!(self.north());
                if self.south() {
                    Direction::South
                } else if self.west() {
                    Direction::West
                } else {
                    Direction::East
                }
            }
            Direction::South => {
                assert!(self.south());
                if self.north() {
                    Direction::North
                } else if self.west() {
                    Direction::West
                } else {
                    Direction::East
                }
            }
            Direction::West => {
                assert!(self.west());
                if self.east() {
                    Direction::East
                } else if self.north() {
                    Direction::North
                } else {
                    Direction::South
                }
            }
            Direction::East => {
                assert!(self.east());
                if self.west() {
                    Direction::West
                } else if self.north() {
                    Direction::North
                } else {
                    Direction::South
                }
            }
        }
    }
}

struct Grid {
    initial: (usize, usize),
    data: Vec<Vec<(Pipe, bool)>>,
    loop_found: bool,
}

impl Index<usize> for Grid {
    type Output = Vec<(Pipe, bool)>;

    fn index(&self, index: usize) -> &Self::Output {
        &self.data[index]
    }
}

impl Index<(usize, usize)> for Grid {
    type Output = (Pipe, bool);

    fn index(&self, index: (usize, usize)) -> &Self::Output {
        &self.data[index.0][index.1]
    }
}

impl IndexMut<usize> for Grid {
    fn index_mut(&mut self, index: usize) -> &mut Self::Output {
        &mut self.data[index]
    }
}

impl IndexMut<(usize, usize)> for Grid {
    fn index_mut(&mut self, index: (usize, usize)) -> &mut Self::Output {
        &mut self.data[index.0][index.1]
    }
}

impl Grid {
    fn new(input: String) -> Self {
        let chars = input
            .lines()
            .map(|l| l.chars().collect::<Vec<_>>())
            .collect::<Vec<_>>();

        let mut initial = (0, 0);

        let mut data = chars
            .into_iter()
            .enumerate()
            .map(|(x, row)| {
                row.into_iter()
                    .enumerate()
                    .map(|(y, c)| {
                        if c == 'S' {
                            initial = (x, y);
                            Pipe::Ground
                        } else {
                            Pipe::from(c)
                        }
                    })
                    .map(|pipe| (pipe, false))
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();

        // replace start with correct pipe
        let north = initial.0 > 0 && data[initial.0 - 1][initial.1].0.south();
        let south = initial.0 < data.len() - 1 && data[initial.0 + 1][initial.1].0.north();
        let west = initial.1 > 0 && data[initial.0][initial.1 - 1].0.east();
        let east = initial.1 < data[initial.0].len() - 1 && data[initial.0][initial.1 + 1].0.west();

        data[initial.0][initial.1] = (Pipe::from((north, south, west, east)), true);

        Self {
            initial,
            data,
            loop_found: false,
        }
    }

    fn loop_length(&mut self) -> usize {
        let mut from;
        let mut pos;

        if self[self.initial].0.north() {
            from = Direction::South;
            pos = Direction::North.apply(self.initial);
        } else if self[self.initial].0.south() {
            from = Direction::North;
            pos = Direction::South.apply(self.initial);
        } else if self[self.initial].0.west() {
            from = Direction::East;
            pos = Direction::West.apply(self.initial);
        } else if self[self.initial].0.east() {
            from = Direction::West;
            pos = Direction::East.apply(self.initial);
        } else {
            panic!("Invalid initial pipe");
        }

        self[pos].1 = true;

        let mut steps = 1;

        while pos != self.initial {
            let tmp = self[pos].0.other(from);
            pos = tmp.apply(pos);
            from = tmp.opposite();

            self[pos].1 = true;

            steps += 1;
        }

        self.loop_found = true;

        return steps;
    }

    fn area_inside(&self) -> usize {
        assert!(self.loop_found);

        let mut area = 0;

        for row in self.data.iter() {
            let mut inside = false;
            let mut front_north = false;

            for &(pipe, cell) in row {
                if cell {
                    match pipe {
                        Pipe::Horizontal => {}
                        Pipe::Vertical => {
                            inside = !inside;
                        }
                        Pipe::NorthEast => {
                            front_north = true;
                        }
                        Pipe::NorthWest => {
                            if !front_north {
                                inside = !inside;
                            }
                        }
                        Pipe::SouthWest => {
                            if front_north {
                                inside = !inside;
                            }
                        }
                        Pipe::SouthEast => {
                            front_north = false;
                        }
                        Pipe::Ground => unreachable!(),
                    }
                } else {
                    if inside {
                        area += 1;
                    }
                }
            }
        }

        area
    }
}

fn main() -> Result<(), &'static str> {
    let args = std::env::args();

    if args.len() != 2 {
        return Err("Please specify an input file");
    }

    let input = std::fs::read_to_string(args.skip(1).next().unwrap()).unwrap();

    let mut grid = Grid::new(input);

    println!("{}", grid.loop_length() / 2);

    println!("{}", grid.area_inside());

    Ok(())
}
