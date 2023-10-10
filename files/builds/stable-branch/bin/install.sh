#!/usr/bin/python	

############################################################################################################################
# Name:         Autodesk Fusion 360 - Setup Wizard (Linux)                                                                 #
# Description:  With this file you can install Autodesk Fusion 360 on different Linux distributions.                       #
# Author:       Steve Zabka                                                                                                #
# Author URI:   https://cryinkfly.com                                                                                      #
# License:      MIT                                                                                                        #
# Time/Date:    xx:xx/xx.xx.2023                                                                                           #
# Version:      2.0.0                                                                                                      #
# Requires:     "?" <-- Minimum for the installer!                                                                         #
# Optional:     Python version: "3.5<" and pip version: "20.3<" <-- Support Vosk (Speech recognition toolkit)              #
############################################################################################################################

import gi
import os

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gtk, Gdk, GLib

##############################################################################################################################################################################
# CONFIGURATION OF THE DIRECTORY STRUCTURE:                                                                                                                                  #
##############################################################################################################################################################################

os.system('mkdir -p $HOME/.fusion360/{bin,config,locale/{cs-CZ,de-DE,en-US,es-ES,fr-FR,it-IT,ja-JP,ko-KR,zh-CN},wineprefixes,resources/{css,extensions,graphics,music,downloads},logs,cache}')

##############################################################################################################################################################################
# DOWNLOADING THE LICENSES OF THE LANGUAGES FOR THE INSTALLER:                                                                                                               #
##############################################################################################################################################################################

os.system('curl -o $HOME/.fusion360/locale/cs-CZ/license-cs.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/cs-CZ/license-cs.txt')
os.system('curl -o $HOME/.fusion360/locale/de-DE/license-de.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/de-DE/license-de.txt')
os.system('curl -o $HOME/.fusion360/locale/en-US/license-en.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/en-US/license-en.txt')
os.system('curl -o $HOME/.fusion360/locale/es-ES/license-es.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/es-ES/license-es.txt')
os.system('curl -o $HOME/.fusion360/locale/fr-FR/license-fr.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/fr-FR/license-fr.txt')
os.system('curl -o $HOME/.fusion360/locale/it-IT/license-it.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/it-IT/license-it.txt')
os.system('curl -o $HOME/.fusion360/locale/ja-JP/license-ja.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/ja-JP/license-ja.txt')
os.system('curl -o $HOME/.fusion360/locale/ko-KR/license-ko.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/ko-KR/license-ko.txt')
os.system('curl -o $HOME/.fusion360/locale/zh-CN/license-zh.txt https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/locale/zh-CN/license-zh.txt')

##############################################################################################################################################################################
# ALL DIALOGS ARE ARRANGED HERE:                                                                                                                                             #
##############################################################################################################################################################################

#######################
# win1 = Assistant_EN #
##############################################################################################################################################################################

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
        
        open_license_text = open("../locale/en-US/license-en.txt", "r")
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
        win1.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win1.set_page_complete(self.license, checkbutton.get_active())


#######################
# win2 = Assistant_CZ #
##############################################################################################################################################################################

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
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Vítejte v instalačním programu Autodesk Fusion 360 pro Linux</span>\n\n"
                                 "Tento průvodce nastavením vám pomůže nainstalovat Autodesk Fusion 360 do počítače.\n\n"
                                 "- Před pokračováním v této instalaci důrazně doporučujeme zavřít všechny ostatní aplikace.\n\n"
                                 "- Kromě toho je nutné aktivní připojení k internetu, abyste mohli získat všechny potřebné balíčky.\n\n"
                                 "Pokračujte kliknutím na <span font-weight='semi-bold'>'Další'</span>. Pokud potřebujete zkontrolovat nebo změnit některá nastavení instalace, klikněte na <span font-weight='semi-bold'> 'Předchozí'</span>.\n\n"
                                 "Kliknutím na <span font-weight='semi-bold'>'Storno'</span> zrušíte instalaci a ukončíte průvodce.")
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
        
        open_license_text = open("../locale/cs-CZ/license-cs.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="Přečetl jsem si podmínky a souhlasím s nimi.")
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
        win2.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win2.set_page_complete(self.license, checkbutton.get_active())


# #####################
# win3 = Assistant_DE #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  Willkommen  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Willkommen beim Autodesk Fusion 360 Installer für Linux</span>\n\n"
                                 "Dieser Setup-Assistent hilft Ihnen bei der Installation von Autodesk Fusion 360 auf Ihrem Computer.\n\n"
                                 "- Es wird dringend empfohlen, alle anderen Anwendungen zu schließen, bevor Sie mit dieser Installation fortfahren.\n\n"
                                 "- Darüber hinaus ist eine aktive Internetverbindung erforderlich, um alle notwendigen Pakete beziehen zu können.\n\n"
                                 "Klicken Sie auf <span font-weight='semi-bold'>'Weiter'</span>, um fortzufahren. Wenn Sie Ihre Installationseinstellungen überprüfen oder ändern müssen, klicken Sie auf <span font-weight='semi-bold'> 'Zurück'</span>.\n\n"
                                 "Klicken Sie auf <span font-weight='semi-bold'>'Abbrechen'</span>, um die Installation abzubrechen und den Assistenten zu verlassen.")
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
        self.set_page_title(self.license, "  Lizenzvereinbarung  ")
        
        open_license_text = open("../locale/de-DE/license-de.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="Ich habe die Lizenzbestimmungen gelesen und akzeptiere diese.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Individualisierung  ")
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
        self.set_page_title(box, "  Zusammenfassung  ")
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
        win3.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win3.set_page_complete(self.license, checkbutton.get_active())


#######################
# win4 = Assistant_ES #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  Bienvenido  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Bienvenido al instalador de Autodesk Fusion 360 para Linux</span>\n\n"
                                 "Este asistente de configuración le ayudará a instalar Autodesk Fusion 360 en su computadora.\n\n"
                                 "- Se recomienda encarecidamente que cierre todas las demás aplicaciones antes de continuar con esta instalación.\n\n"
                                 "- Además, se requiere una conexión a Internet activa para poder obtener todos los paquetes necesarios.\n\n"
                                 "Haga clic en <span font-weight='semi-bold'>'Siguiente'</span> para continuar. Si necesita revisar o cambiar alguna de las configuraciones de instalación, haga clic en <span font-weight='semi-bold'> 'Anterior'</span>.\n\n"
                                 "Haga clic en <span font-weight='semi-bold'>'Cancelar'</span> para cancelar la instalación y salir del asistente.")
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
        self.set_page_title(self.license, "  Acuerdo de licencia  ")
        
        open_license_text = open("../locale/ja-JP/license-ja.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="He leído los términos y condiciones y los acepto.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Personalización  ")
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
        self.set_page_title(box, "  Instalación  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Sumario  ")
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
        win4.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win4.set_page_complete(self.license, checkbutton.get_active())


#######################
# win5 = Assistant_FR #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  Accueil  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Bienvenue dans le programme d'installation d'Autodesk Fusion 360 pour Linux</span>\n\n"
                                 "Cet assistant de configuration vous aidera à installer Autodesk Fusion 360 sur votre ordinateur.\n\n"
                                 "- Il est fortement recommandé de fermer toutes les autres applications avant de poursuivre cette installation.\n\n"
                                 "- De plus, une connexion Internet active est requise afin de pouvoir obtenir tous les packages nécessaires.\n\n"
                                 "Cliquez sur <span font-weight='semi-bold'>'Suivant'</span> pour continuer. Si vous devez revoir ou modifier l'un de vos paramètres d'installation, cliquez sur <span font-weight='semi-bold'> 'Précédent'</span>.\n\n"
                                 "Cliquez sur <span font-weight='semi-bold'>'Annuler'</span> pour annuler l'installation et quitter l'assistant.")
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
        self.set_page_title(self.license, "  Accord de licence  ")
        
        open_license_text = open("../locale/fr-FR/license-fr.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="J'ai lu les termes et conditions et je les accepte.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Personnalisation  ")
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
        self.set_page_title(box, "  Sommaire  ")
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
        win5.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win5.set_page_complete(self.license, checkbutton.get_active())


#######################
# win6 = Assistant_IT #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  Benvenuto  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Benvenuti nel programma di installazione di Autodesk Fusion 360 per Linux</span>\n\n"
                                 "Questa configurazione guidata ti aiuterà a installare Autodesk Fusion 360 sul tuo computer.\n\n"
                                 "- Si consiglia vivamente di chiudere tutte le altre applicazioni prima di continuare con questa installazione.\n\n"
                                 "- Inoltre è necessaria una connessione Internet attiva per poter ottenere tutti i pacchetti necessari.\n\n"
                                 "Fai clic su <span font-weight='semi-bold'>'Avanti'</span> per procedere. Se devi rivedere o modificare le impostazioni di installazione, fai clic su <span font-weight='semi-bold'> 'Precedente'</span>.\n\n"
                                 "Fai clic su <span font-weight='semi-bold'>'Annulla'</span> per annullare l'installazione e uscire dalla procedura guidata.")
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
        self.set_page_title(self.license, "  Contratto di licenza  ")
        
        open_license_text = open("../locale/it-IT/license-it.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="Ho letto i termini e le condizioni e li accetto.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  Personalizzazione  ")
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
        self.set_page_title(box, "  Installazione  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  Sommario  ")
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
        win6.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win6.set_page_complete(self.license, checkbutton.get_active())


#######################
# win7 = Assistant_JP #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  いらっしゃいませ  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Linux 用 Autodesk Fusion 360 インストーラへようこそ</span>\n\n"
                                 "このセットアップ ウィザードは、Autodesk Fusion 360 をコンピュータにインストールするのに役立ちます。\n\n"
                                 "- このインストールを続行する前に、他のアプリケーションをすべて閉じることを強くお勧めします。\n\n"
                                 "- さらに、必要なパッケージをすべて入手するには、アクティブなインターネット接続が必要です。\n\n"
                                 "「<span font-weight='semi-bold'>[次へ]</span> をクリックして続行します。インストール設定を確認または変更する必要がある場合は、<span font-weight='semi-bold'> をクリックしてください 「前」</span>。\n\n"
                                 "「インストールをキャンセルしてウィザードを終了するには、<span font-weight='semi-bold'>[キャンセル]</span> をクリックしてください。」")
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
        self.set_page_title(self.license, "  ライセンス契約  ")
        
        open_license_text = open("../locale/ja-JP/license-ja.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="利用規約を読み、同意します。")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  カスタマイズ  ")
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
        self.set_page_title(box, "  インストール  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  まとめ  ")
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
        win7.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win7.set_page_complete(self.license, checkbutton.get_active())


#######################
# win8 = Assistant_KO #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  환영  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>Linux용 Autodesk Fusion 360 설치 프로그램에 오신 것을 환영합니다</span>\n\n"
                                 "이 설정 마법사는 컴퓨터에 Autodesk Fusion 360을 설치하는 데 도움이 됩니다.\n\n"
                                 "- 이 설치를 계속하기 전에 다른 모든 애플리케이션을 닫는 것이 좋습니다.\n\n"
                                 "- 또한 필요한 모든 패키지를 얻으려면 활성 인터넷 연결이 필요합니다.\n\n"
                                 "계속하려면 <span font-weight='semi-bold'>'다음'</span>을 클릭하세요. 설치 설정을 검토하거나 변경해야 하는 경우 <span font-weight='semi-bold'>를 클릭하세요. '이전'</span>.\n\n"
                                 "설치를 취소하고 마법사를 종료하려면 <span font-weight='semi-bold'>'취소'</span>를 클릭하세요.")
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
        self.set_page_title(self.license, "  라이센스 계약  ")
        
        open_license_text = open("../locale/ko-KR/license-ko.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="이용약관을 읽었으며 이에 동의합니다.")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  맞춤화  ")
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
        self.set_page_title(box, "  설치  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  요약  ")
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
        win8.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win8.set_page_complete(self.license, checkbutton.get_active())


#######################
# win9 = Assistant_CN #
##############################################################################################################################################################################

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
        self.set_page_title(box, "  歡迎  ")
        label_0 = Gtk.Label(label="<span color='#0a171f' font-weight='bold' size='16000'>歡迎使用適用於 Linux 的 Autodesk Fusion 360 安裝程式</span>\n\n"
                                 "此安裝精靈將協助您在電腦上安裝 Autodesk Fusion 360。\n\n"
                                 "- 強烈建議您在繼續此安裝之前關閉所有其他應用程式。\n\n"
                                 "- 此外，需要有效的網路連線才能取得所有必需的軟體包。\n\n"
                                 "點擊 <span font-weight='semi-bold'>'下一步'</span>繼續。如果您需要檢查或更改任何安裝設置，請點擊 <span font-weight='semi-bold'>'上一個'</span>。\n\n"
                                 "點選 <span font-weight='semi-bold'>'取消'</span>取消安裝並退出精靈。")
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
        self.set_page_title(self.license, "  授權協議  ")
        
        open_license_text = open("../locale/zh-CN/license-zh.txt", "r")
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

        checkbutton = Gtk.CheckButton(label="我已閱讀條款和條件並接受它們。")
        checkbutton.set_name('text') # assign CSS settings
        checkbutton.connect("toggled", self.on_license_toggled)
        self.license.pack_start(checkbutton, False, False, 20)

        # -------------------------------------------------------------------------------------------------

        self.complete = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(self.complete)
        self.set_page_type(self.complete, Gtk.AssistantPageType.PROGRESS)
        self.set_page_title(self.complete, "  客製化  ")
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
        self.set_page_title(box, "  安裝  ")
        label = Gtk.Label(label="The 'Confirm' page may be set as the final page in the Assistant, however this depends on what the Assistant does. This page provides an 'Apply' button to explicitly set the changes, or a 'Go Back' button to correct any mistakes.")
        label.set_line_wrap(True)
        label.set_name('small') # assign CSS settings
        box.pack_start(label, False, False, 0)
        self.set_page_complete(box, True)

        # -------------------------------------------------------------------------------------------------

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.append_page(box)
        self.set_page_type(box, Gtk.AssistantPageType.SUMMARY)
        self.set_page_title(box, "  概括  ")
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
        win9.set_page_complete(self.complete, checkbutton.get_active())

    def on_license_toggled(self, checkbutton):
        win9.set_page_complete(self.license, checkbutton.get_active())

##############################################################################################################################################################################
##############################################################################################################################################################################
##############################################################################################################################################################################

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
