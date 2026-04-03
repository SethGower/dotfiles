{
  config,
  pkgs,
  ...
}: let
  installDir = config.home.homeDirectory + "/.dotfiles";
  wrapWithNixGL = import ../../nix/nixgl-wrap.nix {inherit pkgs;};
in {
  home = {
    username = "sgower";
    homeDirectory = "/home/sgower";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [
    # nvtopPackages.nvidia # htop like utility for graphics
    unstable.ghdl-mcode
    gtkwave
  ];

  # Wrap GPU apps with nixGL for desktop file integration
  programs.ghostty.package = wrapWithNixGL pkgs.ghostty;
  nixpkgs.overlays = [
    (final: prev: {
      wezterm = wrapWithNixGL prev.wezterm;
      keymapp = wrapWithNixGL prev.keymapp;
    })
  ];

  imports = [
    ../../nix/home.nix
    ../../nix/programs
  ];

  dotfiles.dotDir = installDir;
  dotfiles.programs.personal = false;
  dotfiles.programs.wine = false;


  # ensures that the nix profile bin directory is placed in the PATH. System
  # level environment files were clobbering the PATH, so home-manager installed
  # programs weren't showing up in the GNOME app tray. There is also a 99- conf at the system level, but this takes precedence since it's a user one
  home.sessionPath = [ "$HOME/.nix-profile/bin" ];
  xdg.configFile."environment.d/99-nix-path.conf".text = ''
    PATH=$HOME/.nix-profile/bin:$PATH
  '';

  targets.genericLinux.enable = true;
}
