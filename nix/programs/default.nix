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
  };
  imports = [
    ./social.nix
    ./email.nix
  ];
  config = {};
}
