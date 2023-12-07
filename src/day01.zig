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

fn findDigit(line: []const u8, findFirst: bool) ?u8 {
    var final: ?u8 = null;
    var index: u8 = 0;

    var output: []u8 = undefined;

    for (words.kvs) |word| {
        _ = std.mem.replace(u8, line, word.key, words.get(word.key).?, output[0..]);
    }

    if (findFirst) {
        var i: u8 = 0;
        while (i < output.len) : (i += 1) {
            const char = output[i];
            if (char >= '0' and char <= '9') {
                final = char - '0'; // get char by subtracting ASCII value of '0'
                index = i;
            }
        }

        //const word = findWord(line, true);
        //if (word != null and words.has(word.?.word)) {
        //    if (word.?.start < i) {
        //        final = words.get(word.?.word);
        //    }
        //}
    } else {
        var i = output.len;
        while (i > 0) : (i -= 1) {
            const char = output[i - 1];
            if (char >= '0' and char <= '9') {
                final = char - '0'; // get char by subtracting ASCII value of '0'
            }
        }

        //const word = findWord(line, false);
        //if (word != null and words.has(word.?.word)) {
        //    if (word.?.start < i) {
        //        final = words.get(word.?.word);
        //    }
        //}
    }
    return final;
}

const Word = struct { word: []const u8, start: i64 };

fn findWord(line: []const u8, forward: bool) ?Word {
    var start: u32 = if (forward) 0 else @intCast(line.len - 1);

    while ((forward and start < line.len) or (!forward and start >= 0)) : (start += if (forward) 1 else -1) {
        var end: u32 = start;
        while ((forward and end < line.len) or (!forward and end >= 0)) : (end += if (forward) 1 else -1) {}

        return Word{ .word = line[start..end], .start = start };
    }

    return null;
}
