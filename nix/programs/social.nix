{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.dotfiles.programs.personal) {
    home.packages = with pkgs; [
      signal-desktop
      element-desktop
      discord
    ];
  };
}
