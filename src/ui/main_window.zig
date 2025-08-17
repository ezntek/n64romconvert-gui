const std = @import("std");
const qt6 = @import("libqt6zig");
const C = qt6.C;

const QSizePolicy = qt6.qsizepolicy_enums.Policy;
const QtAlignment = qt6.qnamespace_enums.AlignmentFlag;

fn panic() noreturn {
    std.debug.panic("failed to create widget", .{});
}

pub const MainWindowUi = struct {
    main_window: C.QMainWindow,
    central_widget: C.QWidget,
    grid_layout: C.QGridLayout,
    in_label: C.QLabel,
    in_lineedit: C.QLineEdit,
    in_pushbutton: C.QPushButton,
    out_label: C.QLabel,
    out_lineedit: C.QLineEdit,
    out_pushbutton: C.QPushButton,
    ft_label: C.QLabel,
    ft_combobox: C.QComboBox,
    btm_spacer: C.QSpacerItem,
    btm_quit_pushbutton: C.QPushButton,
    btm_confirm_pushbutton: C.QPushButton,
};

pub fn newMainWindowUi(alloc: std.mem.Allocator) *MainWindowUi {
    const self = alloc.create(MainWindowUi) catch panic();

    self.main_window = qt6.qmainwindow.New2() orelse panic();
    self.central_widget = qt6.qwidget.New(self.main_window) orelse panic();
    qt6.qmainwindow.SetCentralWidget(self.main_window, self.central_widget);

    // input file path display and button
    self.grid_layout = qt6.qgridlayout.New(self.central_widget) orelse panic();
    qt6.qgridlayout.SetSpacing(self.grid_layout, 5);
    qt6.qgridlayout.SetContentsMargins(self.grid_layout, 5, 5, 5, 5);

    self.in_label = qt6.qlabel.New3("Input ROM Path: ") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.in_label, 0, 0, 1, 1, QtAlignment.AlignTop);
    qt6.qlabel.SetSizePolicy2(self.in_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.in_lineedit = qt6.qlineedit.New3("") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.in_lineedit, 0, 1, 1, 2, QtAlignment.AlignTop);

    self.in_pushbutton = qt6.qpushbutton.New3("Select File") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.in_pushbutton, 0, 3, 1, 1, QtAlignment.AlignTop);

    self.out_label = qt6.qlabel.New3("Output ROM File Name: ") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.out_label, 1, 0, 1, 1, QtAlignment.AlignTop);
    qt6.qlabel.SetSizePolicy2(self.out_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.out_lineedit = qt6.qlineedit.New3("") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.out_lineedit, 1, 1, 1, 2, QtAlignment.AlignTop);

    self.out_pushbutton = qt6.qpushbutton.New3("Select File") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.out_pushbutton, 1, 3, 1, 1, QtAlignment.AlignTop);

    self.ft_label = qt6.qlabel.New3("Select Output File Type: ") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.ft_label, 2, 0, 1, 2, QtAlignment.AlignTop);
    qt6.qlabel.SetSizePolicy2(self.ft_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.ft_combobox = qt6.qcombobox.New2() orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.ft_combobox, 2, 2, 1, 2, QtAlignment.AlignTop);
    const ft_combobox_texts = [_][]const u8{
        "Autodetect (file extension)",
        "z64 (big endian)",
        "n64 (little endian)",
        "v64 (byteswapped)",
    };
    qt6.qcombobox.AddItems(self.ft_combobox, @constCast(&ft_combobox_texts), alloc);

    self.btm_spacer = qt6.qspaceritem.New4(20, 50, QSizePolicy.Minimum, QSizePolicy.Expanding);
    qt6.qgridlayout.AddItemWithQLayoutItem(self.grid_layout, self.btm_spacer);

    // bottom row
    self.btm_quit_pushbutton = qt6.qpushbutton.New3("Quit") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.btm_quit_pushbutton, 3, 2, 1, 1, QtAlignment.AlignBottom);

    self.btm_confirm_pushbutton = qt6.qpushbutton.New3("Convert") orelse panic();
    qt6.qgridlayout.AddWidget6(self.grid_layout, self.btm_confirm_pushbutton, 3, 3, 1, 1, QtAlignment.AlignBottom);

    return self;
}
