{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ../../modules/common
  ];

  networking.hostName = "wsl";

  # NixOS-WSL specific options are documented on the NixOS-WSL repository:
  # https://github.com/nix-community/NixOS-WSL
  wsl = {
    enable = true;
    defaultUser = vars.user.name;
    startMenuLaunchers = true;
    wslConf = {
      automount.root = "/mnt";
      network.generateResolvConf = true;
    };
  };

  # # Override common settings that don't work well in WSL
  # services = {
  #   xserver.enable = lib.mkForce false;
  #   displayManager.sddm.enable = lib.mkForce false;
  #   desktopManager.plasma6.enable = lib.mkForce false;
  #   pipewire.enable = lib.mkForce false;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home-manager = {
    users.${vars.user.name}.home.stateVersion = "25.05";
  };
}
