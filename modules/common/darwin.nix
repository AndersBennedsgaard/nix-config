{
  inputs,
  outputs,
  pkgs,
  lib,
  vars,
  ...
}: {
  # needed for nixd to expand nix pkgs
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Allow unfree packages at the system level
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "databricks-cli"
      "terraform"
      "claude-code"
      "slack"
      "vscode"
      "obsidian"
    ];

  # Set the primary user for nix-darwin user-specific options
  system.primaryUser = vars.user.name;

  # Darwin-specific configurations from old flake
  system.defaults = {
    dock = {
      autohide = true;
      scroll-to-open = true;
      mru-spaces = false; # automatically rearrange spaces based on recent use
      persistent-apps = [
        "/System/Applications/Mail.app"
        "/Applications/Microsoft Teams.app"
        "/Applications/Nix Apps/Slack.app"
        "/Applications/Spotify.app"
        "/Applications/Nix Apps/Obsidian.app"
        "/Applications/Firefox.app"
        "/Applications/Ghostty.app"
        "/Applications/FortiClient.app"
      ];
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "clmv";
      QuitMenuItem = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };
    controlcenter.BatteryShowPercentage = true;
    hitoolbox.AppleFnUsageType = "Change Input Source";
    loginwindow.GuestEnabled = false;
    loginwindow.autoLoginUser = "Anders Bennedsgaard";
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 1;
      InitialKeyRepeat = 14;
      "com.apple.swipescrolldirection" = false;
    };
    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      EnableTiledWindowMargins = false;
    };
    screencapture = {
      disable-shadow = true;
      target = "clipboard";
      type = "png";
    };
  };

  # Homebrew integration
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "amethyst"
    ];
    taps = [];
    onActivation = {
      # cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Nix configuration similar to NixOS
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # Darwin equivalent of systemPackages
  environment.systemPackages = with pkgs; [
    coreutils
    nixd # new Nix LSP
    alejandra # nix formatter
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.shells = [pkgs.bash pkgs.zsh];

  # Enable programs
  programs.zsh.enable = true;

  # User configuration using Mac username
  users.users.${vars.user.name} = {
    name = vars.user.name;
    home = "/Users/${vars.user.name}";
    shell = pkgs.zsh;
  };

  # Home-manager configuration
  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs vars;
    };
    users.${vars.user.name} = {...}: {
      imports = [../../modules/home/darwin.nix];
    };
  };

  # Font configuration for Darwin
  fonts.packages = [];
}
