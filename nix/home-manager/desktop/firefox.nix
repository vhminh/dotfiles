{ pkgs, username, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      Preferences = {
        "ui.key.menuAccessKeyFocuses" = false; # don't focus menu when pressing Alt
        "sidebar.revamp" = true;
        "sidebar.revamp.round-content-area" = true;
        "sidebar.main.tools" = "history";
        "sidebar.verticalTabs" = true;
      };
    };
  };

  # Nix User Repository
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

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
}
