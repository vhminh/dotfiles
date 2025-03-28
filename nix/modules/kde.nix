{ username }: {config, pkgs, ...}:

{
  imports = [ <home-manager/nixos> ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";
}
