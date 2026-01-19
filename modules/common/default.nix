{
  inputs,
  outputs,
  pkgs,
  vars,
  ...
}: {
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
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
  };

  time.timeZone = vars.system.timeZone;

  console = {
    keyMap = "dk";
  };

  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "${vars.user.fullName}";
    extraGroups = ["networkmanager" "wheel" "podman" "docker"];
    # ignoreShellProgramCheck = true;
    shell = pkgs.${vars.user.packages.shell};
  };

  environment.systemPackages = with pkgs; [
    # python with nix-ld wrapper to fix dynamic linker issues for numpy, pandas, etc.
    (writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${python3}/bin/python "$@"
    '')

    python313
    zsh
    tmux
    git
    htop
    neovim
    just
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # needed for nixd to expand nix pkgs
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  programs.zsh.enable = true;
  # fix dynamic linker issues with python, marksman, etc.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
      icu
    ];
  };

  environment.shells = [pkgs.bash pkgs.zsh];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["-af --volumes"];
      };
    };
    podman.enable = true;
  };
}
