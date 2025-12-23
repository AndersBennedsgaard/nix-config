{...}: {
  user = {
    name = "anders";
    fullName = "Anders Bjørnkjær Bennedsgaard";
    email = "abbennedsgaard@gmail.com";
    packages = {
      terminal = "ghostty";
      editor = "nvim";
      shell = "zsh";
    };
  };

  paths = {
    dotfiles = "$HOME/.dotfiles";
    configHome = "$HOME/.config";
    dataHome = "$HOME/.local/share";
    cacheHome = "$HOME/.cache";
  };

  system = {
    timeZone = "Europe/Copenhagen";
  };

  networking = {
    domain = "local";
  };
}
