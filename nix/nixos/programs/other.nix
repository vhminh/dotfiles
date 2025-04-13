{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gparted
    transmission_3-gtk
    vlc
    anki
    xkeysnail
    chromium
    onlyoffice-bin
    openscad
    blender
    jq
  ];
}
