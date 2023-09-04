{ displayName, email }: { config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gitFull # gitk
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
    xclip

    gcc
    cmake
    gnumake
    sbt
    openjdk17
    go
    nodejs
    rustup
    tree-sitter
    stylua
    lua-language-server
    gopls
    clang-tools
    pyright
    nil

    jetbrains.idea-ultimate
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
  };
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "${displayName}";
        email = "${email}";
      };
    };
  };
}
