{
  description = "Anders's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Mac-/Darwin-specific management
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    # Make Mac GUI apps work
    mac-app-util.url = "github:hraban/mac-app-util";
    mac-app-util.inputs.nixpkgs.follows = "nixpkgs";
    
    # Manage configs in home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Declaratively manage Homebrew. Needed for some GUI apps
    # nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, mac-app-util, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle }:
  let
    # custom variable used elsewhere
    username = "andersbennedsgaard";

    configuration = { pkgs, lib, ... }: {
      # system-wide installations
      environment.systemPackages = [
        pkgs.coreutils
        pkgs.slack
        pkgs.vscode
        pkgs.obsidian
        pkgs.aerospace
        # ghostty can't currently be built with Nix
        # see: https://github.com/NixOS/nixpkgs/issues/388984
        # pkgs.ghostty 
      ];

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "slack"
        "vscode"
        "obsidian"
      ];

      security.pam.services.sudo_local.touchIdAuth = true;

      fonts.packages = [];
  
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

      system.defaults = {
        dock = {
          autohide = true;
          scroll-to-open = true;
          mru-spaces = false; # automatically rearrange spaces based on recent use
          persistent-apps = [
            "/System/Applications/Mail.app"
            "/Applications/Firefox.app"
            "/Applications/Microsoft Teams.app"
            "/Applications/Nix Apps/Slack.app"
            "/Applications/Nix Apps/Obsidian.app"
            "/Applications/Ghostty.app"
            "/Applications/FortiClient.app"
            "/Applications/Spotify.app"
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

      programs.zsh.enable = true;

      environment.shells = [ pkgs.bash pkgs.zsh ];

      # Enable Docker daemon
      # virtualisation.docker.enable = true;
      # Enable Podman
      # virtualisation.podman.enable = true
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#ND361630
    darwinConfigurations."ND361630" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        mac-app-util.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "${username}";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };

            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
            autoMigrate = true;
          };
        }
        home-manager.darwinModules.home-manager
        {
          users.users."${username}".home = "/Users/${username}/";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users."${username}".imports = [
              ({pkgs, ...}: {
                # https://nix-community.github.io/home-manager/options.xhtml
                home = {
                  stateVersion = "24.11";
                  # user-specific installations
                  packages = [
                    pkgs.neovim
                    pkgs.tmux
                    pkgs.act
                    pkgs.jq
                    pkgs.yq-go
                    pkgs.just
                    pkgs.docker
                    pkgs.podman
                    pkgs.podman-tui
                    pkgs.go
                    pkgs.git
                    pkgs.imagemagick
                    pkgs.nodejs_23
                    pkgs.ollama
                    pkgs.openssl
                    pkgs.ruff
                    pkgs.uv
                    pkgs.ripgrep
                    pkgs.shellcheck
                    pkgs.tree
                    pkgs.wget
                    pkgs.curl 
                    pkgs.less
                    pkgs.unixtools.watch
                    pkgs.colima 
                    pkgs.azure-cli
                    pkgs.kubelogin # azure kubelogin
                    pkgs.kubectl
                    pkgs.k9s
                    pkgs.kubernetes-helm
                    pkgs.kustomize
                    pkgs.bun
                  ];
                  # user-specific env vars
                  sessionVariables = {
                    PAGER = "less";
                    CLICOLOR = 1;
                    EDITOR = "nvim";
                    XDG_CONFIG_HOME = "$HOME/.config";
                    XDG_RUNTIME_DIR = "/tmp";
                  };
                  # extra directories to prepend to PATH
                  sessionPath = [
                    "$HOME/.local/bin"
                    "$HOME/go/bin"
                  ];
                  shellAliases = {
                    mktar = "tar -cvf";
                    untar = "tar -xvf";
                    nv = "nvim";
                    ls = "ls --color=auto";
                    l = "ls -lah";
                    la = "ls -lAh";
                    ll = "ls -lh";
                    lsa = "ls -lah";
                  };
                };
                programs = {
                  direnv.enable = true;
                  fzf.enable = true;
                  fzf.enableZshIntegration = true;
                  ghostty.enable = false;
                  ghostty.enableZshIntegration = true;
                  ghostty.settings = {
                    theme = "Ubuntu";
                    macos-option-as-alt = "left";
                    keybind = [
                      "alt+left=unbind"
                      "alt+right=unbind"
                    ];
                  };
                  git.enable = true;
                  git.userEmail = "abbennedsgaard@gmail.com";
                  git.userName = "Anders Bennedsgaard";
                  tmux = {
                    enable = true;
                    baseIndex = 1;
                    clock24 = true;
                    keyMode = "vi";
                    mouse = true;
                    prefix = "C-a";
                    resizeAmount = 1;
                  };
                  zsh = {
                    enable = true;
                    enableCompletion = true;
                    autocd = true;
                    autosuggestion.enable = true;
                    syntaxHighlighting.enable = true;
                    oh-my-zsh = {
                      enable = true;
                      plugins = [
                        "git"
                        "colored-man-pages"
                        "kubectl"
                      ];
                      theme = "robbyrussell";
                    };
                  };
                };
              })
            ];
          };
        }
      ];
    };
  };
}
