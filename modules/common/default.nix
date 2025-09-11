{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  vars,
  ...
} @ args:
# Optional: give a name to the whole argument set
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs vars;
    };
    users.${vars.user.name} = import ../../modules/home;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = vars.system.timeZone;

  console = {
    keyMap = "dk";
  };

  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "${vars.user.fullName}";
    extraGroups = ["networkmanager" "wheel" "podman"];
    # ignoreShellProgramCheck = true;
    shell = pkgs.${vars.user.packages.shell};
  };

  environment.systemPackages = with pkgs; [
    zsh
    tmux
    git
    htop
    neovim
    just
    nixd
    alejandra
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # needed for nixd to expand nix pkgs
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  programs.zsh.enable = true;

  environment.shells = [pkgs.bash pkgs.zsh];

  virtualisation.podman.enable = true;
}
