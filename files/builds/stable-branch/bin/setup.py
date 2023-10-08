#!/usr/bin/python	

import gi, time

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gtk, Gdk, GLib

# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win1 = Assistant_EN
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_EN(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(0)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win2 = Assistant_CZ
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_CZ(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Vítejte  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(1)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  Licenční smlouva  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Přizpůsobení  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Instalace  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Shrnutí  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win2 = Assistant_DE
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_DE(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  DE")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(2)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win4 = Assistant_ES
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_ES(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  ES")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(3)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win5 = Assistant_FR
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_FR(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  FR")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(4)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win6 = Assistant_IT
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_IT(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  IT")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(5)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win7 = Assistant_JP
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_JP(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  JP")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(6)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win8 = Assistant_KO
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_KO(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  KO")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(7)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# win9 = Assistant_CN
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

class Assistant_CN(Gtk.Assistant):
    def __init__(self):
        Gtk.Assistant.__init__(self)
        self.set_title("Autodesk Fusion 360 for Linux - Setup Assistant")
        self.set_default_size(550, -1)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.modify_bg(Gtk.StateFlags.NORMAL,Gdk.color_parse("#ff6a01"))
        self.connect("cancel", self.on_cancel_clicked)
        self.connect("close", self.on_close_clicked)
        self.connect("apply", self.on_apply_clicked)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        provider.load_from_path('style.css')

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_homogeneous(False)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.INTRO)
        self.set_page_title(box, "  Welcome  CN")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Welcome to the Autodesk Fusion 360 Installer for Linux</span>\n\n"
                                "This setup wizard will help you install Autodesk Fusion 360 on your computer.\n\n"
                                "- It is strongly recommended that you close all other applications before continuing with this installation.\n\n"
                                "- In addition, an active internet connection is required in order to be able to obtain all the necessary packages.\n\n"
                                "Click <span font-weight='semi-bold'>'Next'</span> to proceed. If you need to review or change any of your installation settings, click <span font-weight='semi-bold'>'Previous'</span>.\n\n"
                                "Click <span font-weight='semi-bold'>'Cancel'</span> to cancel the installation and exit the wizard.")
        label_0.set_use_markup (True)
        label_0.set_line_wrap(True)
        label_0.set_name('text')
        box.pack_start(label_0, False, False, 0)

        currencies = [
            "English",
            "Czech",
            "German",
            "Spanish",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Chinese",
        ]
        currency_combo = Gtk.ComboBoxText()
        currency_combo.set_entry_text_column(0)
        currency_combo.set_name('padding-left-bottom')
        currency_combo.connect("changed", self.on_currency_combo_changed)
        
        for currency in currencies:
            currency_combo.append_text(currency)

        currency_combo.set_active(8)
        box.pack_end(currency_combo, False, False, 0)




        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        self.license = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.license)
        self.set_page_type(self.license, Gtk.AssistantPageType.CONTENT)
        self.set_page_title(self.license, "  License Agreement  ")
        
        open_license_text = open("assets/license.txt", "r")
        data_license_text = open_license_text.read()

        scrolledwindow = Gtk.ScrolledWindow()
        scrolledwindow.set_min_content_height(400)
        self.license.pack_start(scrolledwindow, False, False, 0)
      
        label_1 = Gtk.Label(label=str(data_license_text))
        label_1.set_use_markup (True)
        label_1.set_line_wrap(True)
        label_1.set_name('text') # assign CSS settings

        scrolledwindow.add(label_1)
        self.license.pack_start(label_1, False, False, 0) 

        checkbutton = Gtk.CheckButton(label="I have read the terms and conditions and I accept them.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Customization  ")
        label = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        self.complete.pack_start(label, False, False, 0)        

        label1 = Gtk.Label(label="A 'Progress' page is used to prevent changing pages within the Assistant before a long-running process has completed. The 'Continue' button will be marked as insensitive until the process has finished. Once finished, the button will become sensitive.")
        label1.set_line_wrap(True)
        label1.set_name('small') # assign CSS settings
        self.complete.pack_start(label1, False, False, 0)

        checkbutton = Gtk.CheckButton(label="Mark page as complete")
        checkbutton.connect("toggled", self.on_complete_toggled)
        self.complete.pack_start(checkbutton, False, False, 0)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.CONFIRM)
        self.set_page_title(box, "  Installation  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Summary  ")
        label = Gtk.Label(label="A 'Summary' should be set as the final page of the Assistant if used however this depends on the purpose of your Assistant. It provides information on the changes that have been made during the configuration or details of what the user should do next. On this page only a Close button is displayed. Once at the Summary page, the user cannot return to any other page.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

    def on_apply_clicked(self, *args):
        print("The 'Apply' button has been clicked")

    def on_close_clicked(self, *args):
        print("The 'Close' button has been clicked")
        Gtk.main_quit()

    def on_cancel_clicked(self, *args):
        print("The Assistant has been cancelled.")
        Gtk.main_quit()

    def on_currency_combo_changed(self, combo):  
        text = combo.get_active_text()
        if text == "Czech":
            print("CZ")  
            win1.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win2.show_all()
        elif text == "English":
            print("EN")  
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win1.show_all()
        elif text == "German":
            print("DE")  
            win1.hide()
            win2.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win3.show_all()
        elif text == "Spanish":
            print("SP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win4.show_all()
        elif text == "French":
            print("FR")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win5.show_all()
        elif text == "Italian":
            print("IT")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win7.hide()
            win8.hide()
            win9.hide()
            win6.show_all()
        elif text == "Japanese":
            print("JP")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win8.hide()
            win9.hide()
            win7.show_all()
        elif text == "Korean":
            print("KO")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win9.hide()
            win8.show_all()
        elif text == "Chinese":
            print("CN")  
            win1.hide()
            win2.hide()
            win3.hide()
            win4.hide()
            win5.hide()
            win6.hide()
            win7.hide()
            win8.hide()
            win9.show_all()
        else :
            print("ERROR")

    def on_complete_toggled(self, checkbutton):
        assistant.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        assistant.set_page_complete(self.license, checkbutton.get_active())

# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

win1 = Assistant_EN()
win2 = Assistant_CZ()
win3 = Assistant_DE()
win4 = Assistant_ES()
win5 = Assistant_FR()
win6 = Assistant_IT()
win7 = Assistant_JP()
win8 = Assistant_KO()
win9 = Assistant_CN()

win1.connect("destroy", Gtk.main_quit)
win2.connect("destroy", Gtk.main_quit)
win3.connect("destroy", Gtk.main_quit)
win4.connect("destroy", Gtk.main_quit)
win5.connect("destroy", Gtk.main_quit)
win6.connect("destroy", Gtk.main_quit)
win7.connect("destroy", Gtk.main_quit)
win8.connect("destroy", Gtk.main_quit)
win9.connect("destroy", Gtk.main_quit)

win1.show_all()
Gtk.main()
