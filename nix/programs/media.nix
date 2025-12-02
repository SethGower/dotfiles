{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    dotfiles.programs.media = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Controls whether or not to include various media programs
      '';
    };
  };
  config = lib.mkIf (config.dotfiles.programs.media && config.dotfiles.programs.personal) {
    home.packages = with pkgs; [
      calibre
      # jellyfin-media-player
      vlc
      tidal-hifi
    ];
  };
}
