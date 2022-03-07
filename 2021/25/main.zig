const std = @import("std");
const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");

pub fn iter(l: ArrayList([] u8)) bool {
    var result = false;
    // clone
    var prev = ArrayList([] u8).init(std.testing.allocator);
    for (l.items) |row| {
        var cpy = Allocator.alloc(std.testing.allocator, u8, row.len) catch return true;
        std.mem.copy(u8, cpy, row);
        prev.append(cpy) catch return true;
    }

    // >
    for (prev.items) |row, y| {
        for (row) |c, x| {
            const next = (x + 1) % l.items[0].len;
            if (c == '>' and prev.items[y][next] == '.') {
                l.items[y][x] = '.';
                l.items[y][next] = '>';
                result = true;
            }
        }
    }
    for (l.items) |row, y| {
        std.mem.copy(u8, prev.items[y], row);
    }

    // v
    for (prev.items) |row, y| {
        const next = (y + 1) % l.items.len;
        for (row) |c, x| {
            if (c == 'v' and prev.items[next][x] == '.') {
                l.items[y][x] = '.';
                l.items[next][x] = 'v';
                result = true;
            }
        }
    }

    prev.deinit();
    return result;
}

pub fn main() !void {
    // parse
    var tokens = std.mem.tokenize(u8, input, "\n");
    var lines = ArrayList([] u8).init(std.testing.allocator);
    while (tokens.next()) |line| {
        var l = try Allocator.alloc(std.testing.allocator, u8, line.len);
        std.mem.copy(u8, l, line);
        try lines.append(l);
    }

    var count: usize = 1;
    while (iter(lines)) {
        count += 1;
    }
    lines.deinit();
    try stdout.print("{d}\n", .{count});
}
