{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    dotfiles.programs.vpn = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Controls whether or not to include the VPN client stuff
      '';
    };
  };
  config = lib.mkIf (config.dotfiles.programs.vpn && config.dotfiles.programs.personal) {
    home.packages = with pkgs; [
      mullvad-vpn
    ];
  };
}
