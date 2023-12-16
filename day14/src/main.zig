const std = @import("std");
const ArrayList = std.ArrayList;

const Direction = enum {
    North,
    West,
    South,
    East,
};

const GridElement = enum {
    Empty,
    Cube,
    Round,
};

const Grid = struct {
    allocator: std.mem.Allocator,
    data: []GridElement,
    size: usize,

    fn init(allocator: std.mem.Allocator, size: usize) !Grid {
        return Grid{
            .allocator = allocator,
            .data = try allocator.alloc(GridElement, size * size),
            .size = size,
        };
    }

    fn deinit(self: Grid) void {
        self.allocator.free(self.data);
    }

    fn clone(self: Grid) !Grid {
        var new_grid = try Grid.init(self.allocator, self.size);

        std.mem.copy(GridElement, new_grid.data, self.data);

        return new_grid;
    }

    fn equals(self: Grid, other: Grid) bool {
        if (self.size != other.size) {
            return false;
        }

        for (0..self.size) |i| {
            for (0..self.size) |j| {
                if (self.data[i * self.size + j] != other.data[i * self.size + j]) {
                    return false;
                }
            }
        }

        return true;
    }

    fn print(self: Grid) !void {
        const stdOutWriter = std.io.getStdOut().writer();

        for (0..self.size) |i| {
            for (0..self.size) |j| {
                switch (self.data[i * self.size + j]) {
                    .Empty => try stdOutWriter.print(".", .{}),
                    .Cube => try stdOutWriter.print("#", .{}),
                    .Round => try stdOutWriter.print("O", .{}),
                }
            }

            try stdOutWriter.print("\n", .{});
        }

        try stdOutWriter.print("\n", .{});
    }

    fn tilt(self: *Grid, direction: Direction) void {
        for (0..self.size) |i| {
            for (0..self.size) |j| {
                const x = if (direction == .South) self.size - i - 1 else i;
                const y = if (direction == .East) self.size - j - 1 else j;

                const idx = x * self.size + y;

                if (self.data[idx] == .Round) {

                    // find empty space to roll to
                    var target = if (direction == .North or direction == .South)
                        x
                    else
                        y;

                    switch (direction) {
                        .North => {
                            while (target > 0 and self.data[(target - 1) * self.size + y] == .Empty) : (target -= 1) {}
                        },
                        .West => {
                            while (target > 0 and self.data[x * self.size + target - 1] == .Empty) : (target -= 1) {}
                        },
                        .South => {
                            while (target < self.size - 1 and self.data[(target + 1) * self.size + y] == .Empty) : (target += 1) {}
                        },
                        .East => {
                            while (target < self.size - 1 and self.data[x * self.size + target + 1] == .Empty) : (target += 1) {}
                        },
                    }

                    // move round to empty space
                    self.data[idx] = .Empty;

                    if (direction == .North or direction == .South) {
                        self.data[target * self.size + y] = .Round;
                    } else {
                        self.data[x * self.size + target] = .Round;
                    }
                }
            }
        }
    }

    fn cycle(self: *Grid) void {
        self.tilt(.North);
        self.tilt(.West);
        self.tilt(.South);
        self.tilt(.East);
    }

    fn cycles(self: *Grid, count: usize) !void {
        var memory = ArrayList(Grid).init(self.allocator);
        defer {
            for (memory.items) |item| {
                item.deinit();
            }

            memory.deinit();
        }

        for (0..count) |_| {
            self.cycle();

            // std.debug.print("{}\n", .{self.load()});

            for (0..memory.items.len) |i| {
                const item = memory.items[i];

                if (self.equals(item)) {
                    const cycle_length = memory.items.len - i;
                    const cycle_start = i;

                    const idx = cycle_start + (count - cycle_start) % cycle_length;

                    std.mem.copy(GridElement, self.data, memory.items[idx - 1].data);

                    return;
                }
            }

            try memory.append(try self.clone());
        }
    }

    fn load(self: Grid) usize {
        var count: usize = 0;

        for (0..self.size) |x| {
            for (0..self.size) |y| {
                const idx = x * self.size + y;

                if (self.data[idx] == .Round) {
                    count += self.size - x;
                }
            }
        }

        return count;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        try std.io.getStdErr().writer().print("Please specify an input file\n", .{});
        return error.Ok;
    }

    const input_file = try std.fs.cwd().openFile(args[1], .{});
    defer input_file.close();

    const reader = input_file.reader();

    var grid: ?Grid = null;
    defer grid.?.deinit();

    var line_n: usize = 0;

    while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 256)) |line| {
        defer allocator.free(line);

        if (grid == null) {
            grid = try Grid.init(allocator, line.len);
        }

        for (0..line.len) |i| {
            const idx = line_n * grid.?.size + i;

            switch (line[i]) {
                '.' => grid.?.data[idx] = .Empty,
                '#' => grid.?.data[idx] = .Cube,
                'O' => grid.?.data[idx] = .Round,
                else => return error.Unreachable,
            }
        }

        line_n += 1;
    }

    const stdOutWriter = std.io.getStdOut().writer();

    grid.?.tilt(.North);

    try stdOutWriter.print("{}\n", .{grid.?.load()});

    try grid.?.cycles(1000000000);

    try stdOutWriter.print("{}\n", .{grid.?.load()});
}
