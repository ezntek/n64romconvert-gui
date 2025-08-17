const std = @import("std");
const qt6 = @import("libqt6zig");
const C = qt6.C;
const rc = @import("n64romconvert");

const util = @import("util.zig");
const panic = util.panic;

const ui_mod = @import("ui/root.zig");
const MainWindowUi = ui_mod.main_window.MainWindowUi;

var counter: isize = 0;

pub const MainWindow = struct {
    ui: *MainWindowUi,
    data: u32,
    slf: C.QVariant, // bound to whoever who needs it

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator) *Self {
        const ui = ui_mod.main_window.newMainWindowUi(alloc);
        const res = Self{
            .ui = ui,
            .data = 0,
            .slf = undefined,
        };
        const a_res = alloc.create(Self) catch |err| panic(err);
        a_res.* = res;

        a_res.setupProperties();
        a_res.setupEvents();

        return a_res;
    }

    fn setupProperties(self: *Self) void {
        self.slf = qt6.qvariant.New7(@intFromPtr(self));
        _ = qt6.qwidget.SetProperty(self.ui.btm_confirm_pushbutton, "self", self.slf);
    }

    fn btnConfirm(btn: ?*anyopaque) callconv(.c) void {
        const self_qv = qt6.qwidget.Property(btn, "self");
        const self: *Self = @ptrFromInt(qt6.qvariant.ToULongLong(self_qv));
        std.debug.print("data: {}\n", .{self.data});
        self.data += 1;
    }

    fn btnQuit(btn: ?*anyopaque) callconv(.c) void {
        _ = btn;
        qt6.qapplication.CloseAllWindows();
    }

    fn setupEvents(self: *Self) void {
        qt6.qpushbutton.OnClicked(self.ui.btm_quit_pushbutton, Self.btnQuit);
        qt6.qpushbutton.OnClicked(self.ui.btm_confirm_pushbutton, Self.btnConfirm);
    }

    pub fn show(self: *const Self) void {
        qt6.qwidget.Show(self.ui.main_window);
    }

    pub fn deinit(self: *const Self, alloc: std.mem.Allocator) void {
        alloc.destroy(self.ui);
        alloc.destroy(self);
    }
};

pub fn main() !void {
    const argc = std.os.argv.len;
    const argv = std.os.argv.ptr;

    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    _ = qt6.qapplication.New(argc, argv);

    const main_window = MainWindow.init(alloc);
    defer main_window.deinit(alloc);
    main_window.show();

    const code = qt6.qapplication.Exec();
    std.process.exit(@intCast(code));
}

fn onclick(btn: ?*anyopaque) callconv(.c) void {
    _ = btn;
    std.debug.print("select file clicked\n", .{});
}
