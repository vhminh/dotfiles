{ displayName, email }: { config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    go
    nodejs
    rustup
    tree-sitter
    lua-language-server
    gopls
    clang-tools
    pyright
    nil
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
