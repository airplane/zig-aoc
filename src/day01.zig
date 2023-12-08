const std = @import("std");

const file = @embedFile("data/day01.txt");

const part2: bool = true;

pub fn main() !void {
    // idk anything about allocators
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var words = std.StringArrayHashMap([]const u8).init(allocator);
    defer words.deinit();

    // This took me so long to realize // I don't know if I need to 'try' but its in the documentation
    try words.put("oneight", "18");
    try words.put("twone", "21");
    try words.put("threeight", "38");
    try words.put("fiveight", "58");
    try words.put("eightwo", "82");
    try words.put("eighthree", "83");
    try words.put("nineight", "98");

    try words.put("zero", "0");
    try words.put("one", "1");
    try words.put("two", "2");
    try words.put("three", "3");
    try words.put("four", "4");
    try words.put("five", "5");
    try words.put("six", "6");
    try words.put("seven", "7");
    try words.put("eight", "8");
    try words.put("nine", "9");

    var sum: u32 = 0;

    var readIter = std.mem.tokenize(u8, file, "\n");
    var replacements: usize = 0;

    while (readIter.next()) |line| {
        var final: [100]u8 = undefined; // this just worked
        std.mem.copy(u8, &final, line); // copying since line is const
        for (0..words.count()) |i| {
            replacements += std.mem.replace(u8, &final, words.keys()[i], words.values()[i], final[0..]);
        }

        const combo = if (part2) findDigit(&final) else findDigit(line);
        if (combo.firstDigit != null and combo.lastDigit != null) {
            sum += (combo.firstDigit.? * 10) + combo.lastDigit.?; // ? gets value out of optionals
        }
    }

    std.debug.print("Replacements: {d}\n", .{replacements});

    std.debug.print("{d}", .{sum});
}

const Combo = struct { firstDigit: ?u8, lastDigit: ?u8 };

fn findDigit(line: []const u8) Combo {
    var firstDigit: ?u8 = null;
    var lastDigit: ?u8 = null;

    var i: u8 = 0;
    while (i < line.len) : (i += 1) {
        const char = line[i];
        if (char >= '0' and char <= '9') {
            if (firstDigit == null) {
                firstDigit = char - '0'; // get char by subtracting ASCII value of '0'
            }
            lastDigit = char - '0';
        }
    }
    return Combo{ .firstDigit = firstDigit, .lastDigit = lastDigit };
}
