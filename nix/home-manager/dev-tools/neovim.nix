{ pkgs, ... }:
{
  imports = [
    ./language-tools
  ];

  home.packages = with pkgs; [
    wget
    curl
    unzip
    fd
    ripgrep
    bat
    fzf
    xclip
    sqlite
    tree-sitter
    nodejs # for treesitter :(
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # extraConfig = ''
    #   let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
    #   let init_lua_path = stdpath('config') . '/init.lua'
    #   if filereadable(init_lua_path)
    #     execute 'luafile ' . init_lua_path
    #   endif
    # ''; # add sqlite3 path for kkharji/sqlite.lua
  };
}
