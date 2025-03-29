{ pkgs, inputs, system, ... }:

let
  bamboo = inputs.ibus-bamboo.packages."${system}".default;
in {
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ table table-others bamboo ];
  };
}
