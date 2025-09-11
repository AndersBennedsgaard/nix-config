{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    git
    neovim
    just
    nixos-rebuild
  ];
}
