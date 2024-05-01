{
  user ? throw "Set this to your user",
  ...
}:
{ pkgs, lib, inputs, ... }:
with lib;
let
  cfg = config.state;
    create-home-persist = pkgs.writers.writeDashBin "create-home-persist"
    ''
      mkdir -p /persist/home/${user} && chown ${user} /persist/home/${user} && chmod rg=rwx,o= /persist/home/${user}
    '';
in
{
  systemd.services."create-home-persist-${user}" = {
    description = "create the home persistence directory for ${user}";
    wantedBy = [ "sysinit.target" ];
    requires = [ "-.mount" ];
    after = [ "-.mount" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = ''${create-home-persist}/bin/create-home-persist'';
  };
}
