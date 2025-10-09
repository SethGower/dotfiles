{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    dotfiles.programs.gnome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables/Disables GNOME configuration
      '';
    };
  };
  config = lib.mkIf (config.dotfiles.programs.gnome) {
    home.packages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
    ];
  };
}
