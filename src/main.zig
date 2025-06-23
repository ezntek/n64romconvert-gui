const std = @import("std");
const qt6 = @import("libqt6zig");
const C = qt6.C;
const rc = @import("n64romconvert");

const ui = @import("ui/root.zig");

var counter: isize = 0;

pub fn main() !void {
    const argc = std.os.argv.len;
    const argv = std.os.argv.ptr;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    _ = qt6.qapplication.New(argc, argv);

    const mw = try ui.main_window.newMainWindowUi(alloc);
    defer alloc.destroy(mw);
    qt6.qwidget.Show(mw.main_window);

    _ = qt6.qapplication.Exec();

    std.debug.print("ok\n", .{});
}

fn onclick(btn: ?*anyopaque) callconv(.c) void {
    _ = btn;
    std.debug.print("select file clicked\n", .{});
}
