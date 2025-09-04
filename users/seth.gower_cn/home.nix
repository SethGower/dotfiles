{
  config,
  pkgs,
  ...
}: let
  installDir = config.home.homeDirectory + "/.dotfiles";
in {
  home = {
    username = "seth.gower_cn";
    homeDirectory = "/home/seth.gower_cn";
    stateVersion = "25.05";
  };

  imports = [
    ../../nix/home.nix
    ../../nix/programs
  ];

  dotfiles.dotDir = installDir;
  dotfiles.programs.personal = false;
}
