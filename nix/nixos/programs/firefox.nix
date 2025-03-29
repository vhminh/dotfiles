{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.firefox ];
  environment.variables = {
    BROWSER = "firefox";
  };
}
