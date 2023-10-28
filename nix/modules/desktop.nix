{ username }: { config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  services.xserver.enable = true;

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.defaultSession = "none+xfce";
  services.xserver.autoRepeatDelay = 250;
  services.xserver.autoRepeatInterval = 30;
  services.xserver.xkbOptions = "ctrl:nocaps";

  services.gnome.gnome-keyring.enable = true;

  programs.xfconf.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-pulseaudio-plugin
  ];

  home-manager.users.${username} = { pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark-compact";
        package = pkgs.materia-theme;
      };
      iconTheme = {
        name = "Flat-Remix-Blue-Dark";
        package = pkgs.flat-remix-icon-theme;
      };
      cursorTheme = {
        name = "macOS-Monterey-White";
        package = pkgs.apple-cursor;
        size = 18;
      };
      font = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
        size = 11;
      };
    };
    xfconf.settings = {
      xsettings = {
        "Net/ThemeName" = "Materia-dark-compact";
        "Net/IconThemeName" = "Flat-Remix-Blue-Dark";
        "Gtk/CursorThemeName" = "macOS-Monterey-White";
        "Gtk/CursorThemeSize" = 18;
        "Gtk/FontName" = "Noto Sans Regular 11";
        "Gtk/MonospaceFontName" = "NotoSansM Nerd Font 10";
      };
      xfwm4 = {
        "general/button_layout" = "O|HMC"; # disable "shade"(S) button
        "general/theme" = "Materia-dark-compact";
        "general/title_font" = "Noto Sans Bold 11";
        "general/mousewheel_rollup" = false;
        "general/move_opacity" = 80;
        "general/resize_opacity" = 80;
        "general/workspace_count" = 2;
        "general/workspace_names" = [ "1" "2" ];
      };
      xfce4-panel = {
        "panels/dark-mode" = true;
        "panels" = [ 1 ];
        "panels/panel-1/icon-size" = 16;
        "panels/panel-1/size" = 36;
        "panels/panel-1/mode" = 0;
        "panels/panel-1/output-name" = "Primary";
        "panels/panel-1/length" = 100.0;
        "panels/panel-1/position" = "p=4;x=0;y=0";
        "panels/panel-1/enable-struts" = true;
        "panels/panel-1/position-locked" = true;
        "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 ];
        # Application menu
        "plugins/plugin-1" = "applicationsmenu";
        "plugins/plugin-1/button-icon" = "windows";
        "plugins/plugin-1/button-title" = "Start";
        "plugins/plugin-1/show-button-title" = true;
        "plugins/plugin-1/show-menu-icons" = true;
        # Windows
        "plugins/plugin-2" = "tasklist";
        "plugins/plugin-2/grouping" = false;
        "plugins/plugin-2/show-handle" = true;
        "plugins/plugin-2/show-labels" = false;
        "plugins/plugin-2/include-all-monitors" = true;
        "plugins/plugin-2/window-scrolling" = false;
        "plugins/plugin-2/sort-order" = 4; # don't sort, allow drag-and-drop
        # Separator
        "plugins/plugin-3" = "separator";
        "plugins/plugin-3/style" = 0; # transparent
        "plugins/plugin-3/expand" = true;
        # Workspaces
        "plugins/plugin-4" = "pager";
        # Separator
        "plugins/plugin-5" = "separator";
        "plugins/plugin-5/style" = 0; # transparent
        # Pulse audio
        "plugins/plugin-6" = "pulseaudio";
        "plugins/plugin-6/enable-keyboard-shortcuts" = true;
        # Sys tray
        "plugins/plugin-7" = "systray";
        # Power manager
        "plugins/plugin-8" = "power-manager-plugin";
        # Notification
        "plugins/plugin-9" = "notification-plugin";
        # Clock
        "plugins/plugin-10" = "clock";
        "plugins/plugin-10/digital-time-font" = "Noto Sans 10";
        "plugins/plugin-10/digital-layout" = 3; # time only
        "plugins/plugin-10/mode" = 2; # digital
        "plugins/plugin-11" = "separator";
        "plugins/plugin-11/style" = 0; # transparent
        "plugins/plugin-12" = "clock";
        "plugins/plugin-12/digital-date-font" = "Noto Sans 10";
        "plugins/plugin-12/digital-date-format" = "%a, %d %b %Y";
        "plugins/plugin-12/digital-layout" = 2; # date only
        "plugins/plugin-12/mode" = 2; # digital
        # Show desktop
        "plugins/plugin-13" = "showdesktop";
      };
    };
  };

}
