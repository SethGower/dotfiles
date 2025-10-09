{
  config,
  pkgs,
  ...
}: let
  installDir = config.home.homeDirectory + "/.dotfiles";
in {
  home = {
    username = "sgower";
    homeDirectory = "/home/sgower";
    stateVersion = "25.05";
  };

  imports = [
    ../../nix/home.nix
    ../../nix/programs
  ];

  dotfiles.dotDir = installDir;
  dotfiles.programs.personal = true;
  dotfiles.programs.wine = true;
}
