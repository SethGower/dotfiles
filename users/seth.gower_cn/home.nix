{
  config,
  pkgs,
  ...
}: let
  installDir = config.home.homeDirectory + "/.dotfiles";
in {
  home = {
    username = "seth.gower_cn";
    homeDirectory = "/home/seth.gower_cn";
    stateVersion = "25.05";
  };

  imports = [
    ../../nix/home.nix
    ../../nix/programs
  ];

  dotfiles.dotDir = installDir;
  dotfiles.programs.personal = false;

  xdg.desktopEntries."org.wezfurlong.wezterm" = {
    name = "WezTerm";
    comment = "Wez's Terminal Emulator";
    # keywords = "shell;prompt;command;commandline;cmd;";
    icon = "org.wezfurlong.wezterm";
    # startupwmclass = "org.wezfurlong.wezterm";
    # tryexec = "wezterm";
    exec = "nixGL wezterm start --cwd .";
    type = "Application";
    categories = ["System" "TerminalEmulator" "Utility"];
    terminal = false;
  };
}
