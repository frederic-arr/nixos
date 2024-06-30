{ unstable, lib, config, ... }:
{
  home.file.".config/Code/User" = {
    source = ./vscode;
    recursive = true;
  };

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    # userSettings = builtins.fromJSON (builtins.readFile ./vscode/settings.json);
    extensions = with unstable.vscode-extensions; [
      pkief.material-icon-theme
      editorconfig.editorconfig
      aaron-bond.better-comments
      usernamehw.errorlens
      eamodio.gitlens
      visualstudioexptteam.vscodeintellicode
      visualstudioexptteam.intellicode-api-usage-examples
      ms-vscode-remote.remote-containers
    ];
  };
}
