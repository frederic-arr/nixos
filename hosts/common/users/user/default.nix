{ pkgs, lib, inputs, ... }:
{
  users.users."user" = {
    isNormalUser = true;
    initialPassword = "user";
    extraGroups = [ "wheel" ];
  };
}
