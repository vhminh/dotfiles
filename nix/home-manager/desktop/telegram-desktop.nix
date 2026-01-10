{ pkgs, ... }:
let telegram-desktop-with-ibus =
  pkgs.symlinkJoin {
    name = "telegram-desktop";
    paths = [ pkgs.telegram-desktop ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/Telegram \
        --set QT_IM_MODULE ibus
    '';
  };
in
{
  home.packages = [ telegram-desktop-with-ibus ];
}
