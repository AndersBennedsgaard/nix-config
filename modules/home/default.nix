{
  pkgs,
  lib,
  vars,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "databricks-cli"
          "terraform"
          "claude-code"
        ];
    };
  };

  # User packages. IE not system packages
  home = {
    username = "${vars.user.name}";
    homeDirectory = "/home/${vars.user.name}";
    packages = with pkgs; [
      neovim
      act
      jq
      just
      go
      imagemagick
      nodejs_24
      ollama
      openssl
      ruff
      uv
      ripgrep
      shellcheck
      tree
      wget
      curl
      less
      unixtools.watch
      kubectl
      k9s
      kubernetes-helm
      kustomize
      bun
      k3d
      zstd
      btop
      golangci-lint
      gotools
      databricks-cli
      gcc # for treesitter
      azure-functions-core-tools
      azure-cli
      mise
      cargo
      nixd
      alejandra
      terraform
      claude-code
      google-cloud-sdk
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
      ls = "ls --color=auto";
      l = "ls -lh";
      ll = "ls -lah";
      la = "ls -lAh";
    };
  };

  # Program settings
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

    git = {
      enable = true;
      userEmail = vars.user.email;
      userName = vars.user.fullName;

      extraConfig = {
        init.defaultBranch = "main";
      };

      includes = [
        {
          path = "/home/${vars.user.name}/projects/work/.gitconfig";
          condition = "gitdir:/home/${vars.user.name}/projects/work/";
        }
      ];
    };

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
      initContent = ''
        eval "$(${pkgs.mise}/bin/mise activate zsh)"
      '';
    };
  };
}
