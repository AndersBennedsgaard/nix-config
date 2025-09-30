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
      font-awesome
      docker-buildx
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
      terminal = "screen-256color";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'moon'
            set -g @rose_pine_host 'on'
          '';
        }
      ];
      extraConfig = ''
        # split panes using b(below) and r(right)
        unbind '"'
        unbind '%'
        bind b split-window -v -c "#{pane_current_path}"
        bind r split-window -h -c "#{pane_current_path}"

        # unbind default arrow key navigation
        unbind Up
        unbind Down
        unbind Left
        unbind Right

        # unbind default arrow key resizing
        unbind C-Up
        unbind C-Down
        unbind C-Left
        unbind C-Right

        # prefix+h/j/k/l to navigate panes
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # prefix+ctrl+h/j/k/l to resize panes
        bind -r C-h resize-pane -L 1
        bind -r C-j resize-pane -D 1
        bind -r C-k resize-pane -U 1
        bind -r C-l resize-pane -R 1

        # open a shell in a popup window
        bind C-t display-popup \
          -d "#{pane_current_path}" \
          -w 60% -h 60% \
          -E "zsh"
      '';
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
