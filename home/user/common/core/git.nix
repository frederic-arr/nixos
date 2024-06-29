{ pkgs, lib, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "User";
    userEmail = "user@example.com";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
}
