const std = @import("std");
const qt6 = @import("libqt6zig");
const C = qt6.C;

const QSizePolicy = qt6.qsizepolicy_enums.Policy;

fn panic() noreturn {
    std.debug.panic("failed to create widget", .{});
}

pub const MainWindowUi = struct {
    main_window: C.QMainWindow,
    central_widget: C.QWidget,
    vbox: C.QVBoxLayout,
    in_hbox: C.QHBoxLayout,
    out_hbox: C.QHBoxLayout,
    ft_hbox: C.QHBoxLayout,
    btm_hbox: C.QHBoxLayout,
    in_label: C.QLabel,
    in_lineedit: C.QLineEdit,
    in_pushbutton: C.QPushButton,
    out_label: C.QLabel,
    out_lineedit: C.QLineEdit,
    out_pushbutton: C.QPushButton,
    ft_label: C.QLabel,
    ft_combobox: C.QComboBox,
    btm_confirm_pushbutton: C.QPushButton,
    btm_info_label: C.QLabel,
};

pub fn newMainWindowUi(alloc: std.mem.Allocator) !*MainWindowUi {
    const self = try alloc.create(MainWindowUi);

    self.main_window = qt6.qmainwindow.New2() orelse panic();
    self.central_widget = qt6.qwidget.New(self.main_window) orelse panic();
    qt6.qmainwindow.SetCentralWidget(self.main_window, self.central_widget);
    self.vbox = qt6.qvboxlayout.New(self.central_widget) orelse panic();
    qt6.qvboxlayout.SetObjectName(self.vbox, "vbox");

    // input file path display and button
    self.in_hbox = qt6.qhboxlayout.New2() orelse panic();
    qt6.qvboxlayout.AddLayout(self.vbox, self.in_hbox);
    qt6.qhboxlayout.SetObjectName(self.in_hbox, "in_hbox");
    qt6.qhboxlayout.SetContentsMargins(self.in_hbox, 5, 5, 5, 5);
    qt6.qhboxlayout.SetSpacing(self.in_hbox, 5);

    self.in_label = qt6.qlabel.New3("Input ROM Path: ") orelse panic();
    qt6.qhboxlayout.AddWidget(self.in_hbox, self.in_label);
    qt6.qlabel.SetObjectName(self.in_label, "in_label");
    qt6.qlabel.SetSizePolicy2(self.in_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.in_lineedit = qt6.qlineedit.New3("") orelse panic();
    qt6.qhboxlayout.AddWidget(self.in_hbox, self.in_lineedit);
    qt6.qlineedit.SetObjectName(self.in_lineedit, "in_lineedit");

    self.in_pushbutton = qt6.qpushbutton.New3("Select File") orelse panic();
    qt6.qhboxlayout.AddWidget(self.in_hbox, self.in_pushbutton);
    qt6.qpushbutton.SetObjectName(self.in_pushbutton, "in_pushbutton");

    // input file path display and button
    self.out_hbox = qt6.qhboxlayout.New2() orelse panic();
    qt6.qvboxlayout.AddLayout(self.vbox, self.out_hbox);
    qt6.qhboxlayout.SetObjectName(self.out_hbox, "out_hbox");
    qt6.qhboxlayout.SetContentsMargins(self.out_hbox, 5, 5, 5, 5);
    qt6.qhboxlayout.SetSpacing(self.out_hbox, 5);

    self.out_label = qt6.qlabel.New3("Output ROM File Name: ") orelse panic();
    qt6.qhboxlayout.AddWidget(self.out_hbox, self.out_label);
    qt6.qlabel.SetObjectName(self.out_label, "out_label");
    qt6.qlabel.SetSizePolicy2(self.out_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.out_lineedit = qt6.qlineedit.New3("") orelse panic();
    qt6.qhboxlayout.AddWidget(self.out_hbox, self.out_lineedit);
    qt6.qlineedit.SetObjectName(self.out_lineedit, "out_lineedit");

    self.out_pushbutton = qt6.qpushbutton.New3("Select File") orelse panic();
    qt6.qhboxlayout.AddWidget(self.out_hbox, self.out_pushbutton);
    qt6.qpushbutton.SetObjectName(self.out_pushbutton, "out_pushbutton");

    // filetype picker
    self.ft_hbox = qt6.qhboxlayout.New2() orelse panic();
    qt6.qvboxlayout.AddLayout(self.vbox, self.ft_hbox);
    qt6.qhboxlayout.SetObjectName(self.ft_hbox, "ft_hbox");
    qt6.qhboxlayout.SetContentsMargins(
        self.ft_hbox,
        5,
        5,
        5,
        5,
    );
    qt6.qhboxlayout.SetSpacing(self.out_hbox, 5);

    self.ft_label = qt6.qlabel.New3("Select Output File Type: ") orelse panic();
    qt6.qhboxlayout.AddWidget(self.ft_hbox, self.ft_label);
    qt6.qlabel.SetObjectName(self.ft_label, "ft_label");
    qt6.qlabel.SetSizePolicy2(self.ft_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.ft_combobox = qt6.qcombobox.New2() orelse panic();
    qt6.qhboxlayout.AddWidget(self.ft_hbox, self.ft_combobox);
    qt6.qcombobox.SetObjectName(self.ft_combobox, "ft_combobox");
    const ft_combobox_texts = [_][]const u8{
        "Autodetect (file extension)",
        "z64 (big endian)",
        "n64 (little endian)",
        "v64 (byteswapped)",
    };
    qt6.qcombobox.AddItems(self.ft_combobox, @constCast(&ft_combobox_texts), alloc);

    // bottom row
    self.btm_hbox = qt6.qhboxlayout.New2() orelse panic();
    qt6.qvboxlayout.AddLayout(self.vbox, self.btm_hbox);
    qt6.qhboxlayout.SetObjectName(self.btm_hbox, "btm_hbox");
    qt6.qhboxlayout.SetContentsMargins(self.btm_hbox, 5, 5, 5, 5);
    qt6.qhboxlayout.SetSpacing(self.btm_hbox, 5);

    self.btm_info_label = qt6.qlabel.New3("Ready") orelse panic();
    qt6.qhboxlayout.AddWidget(self.btm_hbox, self.btm_info_label);
    qt6.qlabel.SetObjectName(self.btm_info_label, "btm_info_label");
    qt6.qlabel.SetSizePolicy2(self.btm_info_label, QSizePolicy.Expanding, QSizePolicy.Preferred);

    self.btm_confirm_pushbutton = qt6.qpushbutton.New3("Convert") orelse panic();
    qt6.qhboxlayout.AddWidget(self.btm_hbox, self.btm_confirm_pushbutton);
    qt6.qpushbutton.SetObjectName(self.btm_confirm_pushbutton, "btm_confirm_pushbutton");

    return self;
}
