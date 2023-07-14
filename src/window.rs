use gtk::prelude::*;
use gtk::{gio, glib};

mod imp {
    use gtk::glib;
    use gtk::subclass::prelude::*;

    #[derive(Default)]
    pub struct ConverterWindow {}

    #[glib::object_subclass]
    impl ObjectSubclass for ConverterWindow {
        const NAME: &'static str = "N64RomConvertConverterWindow";
        type Type = super::ConverterWindow;
        type ParentType = gtk::ApplicationWindow;
    }

    impl ObjectImpl for ConverterWindow {}
    impl WidgetImpl for ConverterWindow {}
    impl WindowImpl for ConverterWindow {}
    impl ApplicationWindowImpl for ConverterWindow {}
}

glib::wrapper! {
    pub struct ConverterWindow(ObjectSubclass<imp::ConverterWindow>)
        @extends gtk::ApplicationWindow, gtk::Window, gtk::Widget,
        @implements gio::ActionGroup, gio::ActionMap, gtk::Accessible, gtk::Buildable,
                    gtk::ConstraintTarget, gtk::Native, gtk::Root, gtk::ShortcutManager;
}
