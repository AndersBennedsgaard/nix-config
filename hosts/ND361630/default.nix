{vars, ...}: {
  imports = [
    ../../modules/common/darwin.nix
  ];

  networking.hostName = "ND361630";

  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Platform-specific configuration
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable sudo authentication with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  # User configuration using Mac username
  users.users.${vars.user.name} = {
    name = vars.user.name;
    home = "/Users/${vars.user.name}";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home-manager = {
    users.${vars.user.name}.home.stateVersion = "24.11";
  };
}
