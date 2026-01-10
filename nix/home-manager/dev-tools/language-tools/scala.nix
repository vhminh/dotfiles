{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coursier
    sbt
    openjdk17
    pyright
    nil
    jetbrains.idea
    scala-cli
  ];
}
