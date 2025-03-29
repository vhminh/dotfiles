{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.displayManager.defaultSession = "none+xfce";
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 30;
  services.xserver.xkb.options = "ctrl:nocaps";

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-pulseaudio-plugin
  ];
}
