{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    unzip

    tmux
    stow
    alacritty
    bat

    ripgrep
    fd
    fzf

    gcc
    cmake
    gnumake
    go
    nodejs
    rustup
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables.EDITOR = "nvim";
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];
}
