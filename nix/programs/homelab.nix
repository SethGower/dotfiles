{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.dotfiles.programs.personal) {
    # Programs that I want to help manage homelab stuff
    home.packages = with pkgs; [
      pgadmin4-desktopmode # Postgresql management tool
    ];
  };
}
