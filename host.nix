{ ... }:
{
  imports =
    [
      (import ./disko.nix { device = "/dev/nvme0n1"; swapSize = "16G"; })
    ];

  networking.hostId = "8a99137d";
}
