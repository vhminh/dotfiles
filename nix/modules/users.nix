{ config, pkgs, ... }:

{
  users.users.minh = {
    isNormalUser = true;
    description = "Minh";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  security.sudo.extraRules = [{
    users = [ "minh" ];
    commands = [{
      command = "ALL";
      options = ["NOPASSWD"];
    }];
  }];
}
