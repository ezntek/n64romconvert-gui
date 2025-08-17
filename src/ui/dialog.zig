const std = @import("std");
const qt6 = @import("libqt6zig");
const C = qt6.C;

const QSizePolicy = qt6.qsizepolicy_enums.Policy;
const QtAlignment = qt6.qnamespace_enums.AlignmentFlag;

fn panic() noreturn {
    std.debug.panic("failed to create widget", .{});
}

pub const DialogUi = struct {
    dialog: C.QDialog,
    grid_layout: C.QGridLayout,
    label: C.QLabel,
    btns: C.QDialogButtonBox,
};

pub fn newDialog(alloc: std.mem.Allocator, text: []const u8) *DialogUi {
    const self = alloc.create(DialogUi) catch panic();
    _ = text;
    self.dialog = qt6.qdialog.New2();
    self.layout = qt6.qgridlayout.New(self.dialog);
    self.label = qt6.qlabel.New3("Must specify both input path and output path!");
    qt6.qlabel.SetSizePolicy2(self.label, QSizePolicy.Expanding, QSizePolicy.Preferred);
    qt6.qgridlayout.AddItem5(self.layout, self.label, 0, 0, 1, 0);
    const bbox = qt6.qdialogbuttonbox.New4(qt6.qdialogbuttonbox_enums.StandardButton.Ok);
    _ = bbox; // TODO: write

    return self;
}
