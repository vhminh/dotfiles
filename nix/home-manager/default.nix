{ username, ... }:
{
  imports = [
    ./desktop/firefox.nix
    ./desktop/telegram-desktop.nix
    ./desktop/xfce.nix

    ./dev-tools/alacritty.nix
    ./dev-tools/git.nix
    ./dev-tools/neovim.nix
    ./dev-tools/tmux.nix
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
