const std = @import("std");

const file = @embedFile("data/day01.txt");

const words = std.ComptimeStringMap([]const u8, .{
    .{ "zero", "0" },
    .{ "one", "1" },
    .{ "two", "2" },
    .{ "three", "3" },
    .{ "four", "4" },
    .{ "five", "5" },
    .{ "six", "6" },
    .{ "seven", "7" },
    .{ "eight", "8" },
    .{ "nine", "9" },
});

pub fn main() !void {
    var sum: u32 = 0;

    var readIter = std.mem.tokenize(u8, file, "\n");
    while (readIter.next()) |line| {
        const first_digit = findDigit(line, true);
        const last_digit = findDigit(line, false);

        if (first_digit != null and last_digit != null) {
            sum += (first_digit.? * 10) + last_digit.?; // ? gets value out of optionals
        }
    }

    std.debug.print("{d}", .{sum});
}

test "Example File" {
    const test_file = @embedFile("test_data/day01.txt");
    var sum: u32 = 0;
    var readIter = std.mem.tokenize(u8, test_file, "\n");
    while (readIter.next()) |line| {
        const first_digit = findDigit(line, true);
        const last_digit = findDigit(line, false);

        if (first_digit != null and last_digit != null) {
            sum += (first_digit.? * 10) + last_digit.?; // ? gets value out of optionals
        }
    }

    std.debug.print("{d}", .{sum});
}

fn findDigit(line: []const u8, forward: bool) ?u8 {
    var final: ?u8 = null;
    var index: u8 = 0;

    var output: []u8 = undefined;

    // TODO: Do more testing with indexOf, this std.mem.replace is segfaulting
    for (0..9) |i| {
        //std.debug.print("{s} {s}\n", .{words.kvs[i].key, words.get(words.kvs[i].key).?});
        _ = std.mem.replace(u8, line, words.kvs[i].key, words.get(words.kvs[i].key).?, output[0..]);
        
    }
    //for (words.kvs) |word| {
    //    _ = std.mem.replace(u8, line, word.key, words.get(word.key).?, output[0..]);
    //}

    if (forward) {
        var i: u8 = 0;
        while (i < line.len) : (i += 1) {
            const char = line[i];
            if (char >= '0' and char <= '9') {
                final = char - '0'; // get char by subtracting ASCII value of '0'
                index = i;
            }
        }
    } else {
        var i = line.len;
        while (i > 0) : (i -= 1) {
            const char = line[i - 1];
            if (char >= '0' and char <= '9') {
                final = char - '0'; // get char by subtracting ASCII value of '0'
            }
        }
    }
    return final;
}
