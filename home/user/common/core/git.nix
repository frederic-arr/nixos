{ pkgs, lib, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "User";
    userEmail = "user@example.com";
  };

  programs.gh.enable = true;
}
