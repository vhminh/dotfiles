{ displayName, email }: { config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

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
    sqlite
    htop

    gcc
    cmake
    gnumake
    coursier
    sbt
    openjdk17
    go
    nodejs
    rustup
    tree-sitter
    stylua
    luajitPackages.luacheck
    lua-language-server
    gopls
    clang-tools
    pyright
    nil

    docker
    docker-compose

    jetbrains.idea-ultimate
    jetbrains.jdk

    wabt
    wasmtime
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      # add sqlite3 path for kkharji/sqlite.lua
      customRC = ''
        let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
        let init_lua_path = stdpath('config') . '/init.lua'
        if filereadable(init_lua_path)
          execute 'luafile ' . init_lua_path
        endif
      '';
    };
  };
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
  };
  fonts.packages = with pkgs; [
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
