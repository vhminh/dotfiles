{ config, pkgs, minh, ... }:

{
  imports = [ <home-manager/nixos> ];

  services.xserver.enable = true;

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.defaultSession = "none+xfce";

  services.gnome.gnome-keyring.enable = true;

  programs.xfconf.enable = true;

  home-manager.users.minh = { pkgs, ... }: {
    home.packages = [];
    xfconf.settings = {
      xfce4-panel = {
        "panels/dark-mode" = true;
      };
    };
    home.stateVersion = "23.05";
  };

}
