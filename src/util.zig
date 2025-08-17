const std = @import("std");

pub fn panic(data: anytype) noreturn {
    std.debug.print("panic: {any}\n", .{data});
    std.process.exit(1);
}
