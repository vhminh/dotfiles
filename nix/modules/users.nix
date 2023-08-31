{ username, displayName }: { config, pkgs, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "${displayName}";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  security.sudo.extraRules = [{
    users = [ "${username}" ];
    commands = [{
      command = "ALL";
      options = ["NOPASSWD"];
    }];
  }];
}
