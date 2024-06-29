{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "ls -l";
    };

    history = {
      size = 10000;
      ignoreDups = false;
      extended = true;
      expireDuplicatesFirst = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };

    historySubstringSearch = {
      enable = true;
      searchDownKey = "$terminfo[kDN]";
      searchUpKey = "$terminfo[kUP]";
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" ];
    };
  };
}