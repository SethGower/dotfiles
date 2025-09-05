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
  config = lib.mkIf (config.dofiles.programs.email) {
    services.protonmail-bridge.enable = true;

    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-bin;
    };
  };
}
