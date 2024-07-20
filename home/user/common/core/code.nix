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
      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github
      ms-azuretools.vscode-docker
      esbenp.prettier-vscode
      rust-lang.rust-analyzer
      golang.go
    ];
  };
}
