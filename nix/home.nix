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
  config = let
    symlink = config.lib.file.mkOutOfStoreSymlink;
    xdg_config_entry = name: {
      source = /. + "../config/" + name;
      recursive = true;
    };
    dotsLocation = config.dotfiles.dotDir;
  in {
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
      silver-searcher # A code searching tool similar to ack, with a focus on speed. (binary name `ag`)
      fd # Fast find alternative
      direnv # Directory based environment switching

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
      nvtopPackages.amd # htop like utility for graphics
      glxinfo # OpenGL info

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
      traceroute

      # Terminal stuff
      alacritty # GPU accelerated Terminal
      wezterm # GPU accelerated Terminal
      zellij # Terminal Multiplexer/Session manager
      nushell

      # media stuff
      tidal-hifi

      # Language Servers
      nil # nix Language server
      vhdl-ls # VHDL Language server, also called rust_hdl
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
    programs.bat = {
      enable = true;
      config = {
        theme = "Dracula";
      };
    };

    programs.ghostty = {
      enable = true;
      settings = {
        clipboard-read = "allow";
        # clipboard-paste-protecton = false;
        theme = "catppuccin-mocha";
        font-family = "Iosevka VHDL";
      };
    };

    services.caffeine.enable = true;

    # programs.zsh = {
    #   enable = true;
    #   enableCompletions = true;
    #   autosuggestions.enable = true;
    #   syntaxHighlighting.enable = true;
    #
    #   oh-my-zsh = {
    #     enable = true;
    #     plugins = [
    #       "git"
    #       "thefuck"
    #       "zsh-autosuggestions"
    #       "zsh-syntax-highlighting"
    #       "sudo"
    #       "dirven"
    #     ];
    #     # theme = "robbyrussell";
    #   };
    # };

    # programs.git = {
    #   enable = true;
    #   include.path = "~/.gitconfig.local";
    #   aliases = {
    #     stash-all = "stash save --include-untracked";
    #     showtool = "!f() { git difftool $1^ $1; }; f";
    #     added = "difftool --cached";
    #     update-subs = "submodule update --init --recursive --remote";
    #   };
    #   diff.tool = "meld";
    #   pager.difftool = true;
    #   gpg.program = "gpg";
    #   core = {
    #     excludesfile = "~/.gitignore_global";
    #     autocrlf = true;
    #   };
    #   init = {
    #     defaultBranch = "main";
    #   };
    # };
    # xdg.configFile = lib.map (x: xdg_config_entry x) ["nvim" "alacritty"];
    xdg.configFile = {
      "alacritty" = {
        source = ../config/alacritty;
        recursive = true;
      };
      "nvim" = {
        source = symlink "${dotsLocation}/config/nvim";
        recursive = true;
      };
      "zellij" = {
        source = ../config/zellij;
        recursive = true;
      };
      "wezterm" = {
        source = ../config/wezterm;
        recursive = true;
      };
    };
  };
}
