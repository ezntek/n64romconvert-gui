const std = @import("std");
const rc = @import("n64romconvert");

const qt6 = @import("libqt6zig");
const C = qt6.C;
const QSizePolicy = qt6.qsizepolicy_enums.Policy;
const QtAlignment = qt6.qnamespace_enums.AlignmentFlag;

const ui_mod = @import("ui/root.zig");
const MainWindowUi = ui_mod.main_window.MainWindowUi;

const util = @import("util.zig");
const panic = util.panic;

var counter: isize = 0;

pub const MainWindow = struct {
    alloc: std.mem.Allocator,
    ui: *MainWindowUi,
    data: u32,
    slf: C.QVariant, // bound to whoever who needs it
    in_path: ?[]const u8,
    out_path: ?[]const u8,

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator) *Self {
        const ui = ui_mod.main_window.newMainWindowUi(alloc);
        const res = Self{
            .alloc = alloc,
            .ui = ui,
            .data = 0,
            .slf = undefined,
            .in_path = null,
            .out_path = null,
        };
        const a_res = alloc.create(Self) catch |err| panic(err);
        a_res.* = res;

        a_res.setupProperties();
        a_res.setupEvents();

        return a_res;
    }

    fn setupProperties(self: *Self) void {
        self.slf = qt6.qvariant.New7(@intFromPtr(self));
        _ = qt6.qwidget.SetProperty(self.ui.in_pushbutton, "self", self.slf);
        _ = qt6.qwidget.SetProperty(self.ui.out_pushbutton, "self", self.slf);
        _ = qt6.qwidget.SetProperty(self.ui.btm_confirm_pushbutton, "self", self.slf);
    }

    fn btnSelectInputFile(btn: ?*anyopaque) callconv(.c) void {
        const self_qv = qt6.qwidget.Property(btn, "self");
        const self: *Self = @ptrFromInt(qt6.qvariant.ToULongLong(self_qv));
        const s = qt6.qfiledialog.GetOpenFileName2(btn, "Select Input ROM", self.alloc);
        const in_path = self.alloc.dupe(u8, s) catch |err| panic(err);
        self.in_path = in_path;

        qt6.qlineedit.SetText(self.ui.in_lineedit, in_path);
    }

    fn btnSelectOutputFile(btn: ?*anyopaque) callconv(.c) void {
        const self_qv = qt6.qwidget.Property(btn, "self");
        const self: *Self = @ptrFromInt(qt6.qvariant.ToULongLong(self_qv));
        const s = qt6.qfiledialog.GetOpenFileName2(btn, "Select Output ROM", self.alloc);
        const out_path = self.alloc.dupe(u8, s) catch |err| panic(err);
        self.out_path = out_path;

        qt6.qlineedit.SetText(self.ui.out_lineedit, out_path);
    }

    fn btnConfirm(btn: ?*anyopaque) callconv(.c) void {
        const self_qv = qt6.qwidget.Property(btn, "self");
        const self: *Self = @ptrFromInt(qt6.qvariant.ToULongLong(self_qv));

        if (self.in_path == null or self.out_path == null) {
            return;
        }

        // ComboBox Items:
        // -----
        // "Autodetect (file extension)",
        // "z64 (big endian)",
        // "n64 (little endian)",
        // "v64 (byteswapped)",
        const romtype_lookup = [_]rc.RomType{ .big_endian, .little_endian, .byte_swapped };
        var cur_idx: usize = @intCast(qt6.qcombobox.CurrentIndex(self.ui.out_lineedit));
        if (cur_idx == 0) {
            //
        } else {
            cur_idx -= 1;
            const romtype = romtype_lookup[cur_idx];
            _ = romtype;
        }
    }

    fn btnQuit(btn: ?*anyopaque) callconv(.c) void {
        _ = btn;
        qt6.qapplication.CloseAllWindows();
    }

    fn setupEvents(self: *Self) void {
        qt6.qpushbutton.OnClicked(self.ui.in_pushbutton, Self.btnSelectInputFile);
        qt6.qpushbutton.OnClicked(self.ui.out_pushbutton, Self.btnSelectOutputFile);
        qt6.qpushbutton.OnClicked(self.ui.btm_quit_pushbutton, Self.btnQuit);
        qt6.qpushbutton.OnClicked(self.ui.btm_confirm_pushbutton, Self.btnConfirm);
    }

    pub fn show(self: *const Self) void {
        qt6.qwidget.Show(self.ui.main_window);
    }

    pub fn deinit(self: *const Self, alloc: std.mem.Allocator) void {
        alloc.destroy(self.ui);

        if (self.in_path) |in_path| {
            alloc.free(in_path);
        }

        if (self.out_path) |out_path| {
            alloc.free(out_path);
        }

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
