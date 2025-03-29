{ username, fullname, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "${fullname}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  security.sudo.extraRules = [{
    users = [ "${username}" ];
    commands = [{
      command = "ALL";
      options = ["NOPASSWD"];
    }];
  }];
}
