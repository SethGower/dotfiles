{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    dotfiles.programs.personal = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Controls if personal programs should be installed. Includes things like steam and discord
      '';
    };
    dotfiles.programs.wine = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Controls if WINE should be installed. WINE is used for running Windows programs on Linux.
      '';
    };
  };
  imports = [
    ./social.nix
    ./email.nix
    ./wine.nix
  ];
  config = {};
}
