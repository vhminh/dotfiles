{ username }: { config, pkgs, ... }:

let
  telegram-desktop-with-ibus =
    pkgs.symlinkJoin {
      name = "telegram-desktop";
      paths = [ pkgs.telegram-desktop ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/telegram-desktop \
          --set QT_IM_MODULE ibus
      '';
    };
in
{
  imports = [ <home-manager/nixos> ];

  environment.systemPackages = with pkgs; [
    albert
    telegram-desktop-with-ibus
    gparted
    transmission-gtk
    vlc
    anki
  ];

  home-manager.users.${username} = { pkgs, ... }: {
    # Nix User Repository
    nixpkgs.config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };

    programs.firefox.enable = true;
    programs.firefox.profiles.${username} = {
      bookmarks = [
        {
          name = "Search NixOS packages";
          tags = [ "nix" "nixos" ];
          keyword = "nixos";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "Homemanager options";
          tags = [ "nix" "nixos" "home-manager" ];
          keyword = "home-manager";
          url = "https://nix-community.github.io/home-manager/options.html";
        }
        {
          name = "Nix language";
          tags = [ "nix" ];
          keyword = "nix";
          url = "https://nixos.org/manual/nix/stable/language";
        }
      ];
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
        darkreader
      ];
    };
  };
  environment.variables = {
    BROWSER = "firefox";
  };
}
