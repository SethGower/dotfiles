{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    dotfiles = {
      dotDir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "~/.dotfiles";
        description = ''
          Directory where the dotfiles repo is cloned. MUST BE ABSOLUTE PATH.
        '';
      };
    };
  };
  config = {
    home.packages = with pkgs; [
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

      neofetch
      nnn # terminal file manager

      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern (command is `ag`)
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processor https://github.com/mikefarah/yq
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      silver-searcher # file searcher (more similar to `find` than fzf. command is `ag`)

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      meld # GUI diff tool
      xclip # helper for accessing clipboard contents on CLI
      # gnupg
      iosevka # NerdFont that provides nice glyphs with ligatures
      # nerd-fonts

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      # hugo # static site generator
      # glow # markdown previewer in terminal

      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb

      # Terminal stuff
      ghostty # GPU accelerated terminal
      alacritty # GPU accelerated Terminal
      # wezterm # GPU accelerated Terminal
      zellij # Terminal Multiplexer/Session manager

      # Language Servers
      nil # nix Language server
    ];
    # starship - an customizable prompt for any shell
    programs.starship = {
      enable = false;
      # custom settings
      settings = {
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = false;
      };
    };
  };
}
