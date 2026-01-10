{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    stow
    gparted
    transmission_4-gtk
    vlc
    anki
    xkeysnail
    chromium
    onlyoffice-desktopeditors
    openscad
    blender
    jq
  ];
}
