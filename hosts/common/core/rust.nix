{ pkgs, fenix, system, ... }:
{
  nixpkgs.overlays = [ fenix.overlays.default ];
  environment.systemPackages = with pkgs; [
    gcc
    (fenix.packages.${system}.stable.withComponents [
      "cargo"
      "clippy"
      "rustc"
      "rustfmt"
      "rust-analyzer"
      "rust-src"
    ])
  ];
}
