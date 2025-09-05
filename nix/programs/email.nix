{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    dotfiles.programs.email = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Controls whether or not to include the email client stuff
      '';
    };
  };
  config = lib.mkIf (config.dotfiles.programs.email && config.dotfiles.programs.personal) {
    home.packages = with pkgs; [
      thunderbird-bin
      protonmail-bridge
    ];
  };
}
