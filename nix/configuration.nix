# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        # device = "/dev/disk/by-uuid/2159-BBFE";
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        # extraEntries = ''
        #   menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-42077f60-1a8b-4e1a-9b0f-56160e7caa78' {
        #   	load_video
        #   	set gfxpayload=keep
        #   	insmod gzio
        #   	insmod part_msdos
        #   	insmod fat
        #   	search --no-floppy --fs-uuid --set=root 2159-BBFE
        #   	echo	'Loading Linux linux-lts ...'
        #   	linux	/vmlinuz-linux-lts root=/dev/mapper/MyVolGroup-root rw  loglevel=3 cryptdevice=UUID=737b62a4-7676-47f3-80e6-740b622adef6:cryptlvm root=/dev/MyVolGroup/root ibt=off resume=UUID=e1792b40-1d52-4d31-a734-173c82d15dc9 nvidia_drm.modeset=1 mem_sleep_default=deep splash
        #   	echo	'Loading initial ramdisk ...'
        #   	initrd	/intel-ucode.img /initramfs-linux-lts.img
        #   }
        # '';
      };
    };
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/737b62a4-7676-47f3-80e6-740b622adef6";
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "hammond"; # Define your hostname.

    # networkmanager and wireless are mutually exclusive apparently
    networkmanager.enable = true;

    wireless = {
      enable = false;
      #userControlled.enable = true;
      networks."Furry Little Pig".pskRaw = "48ccae435a7e6caad37910dc2c4794473af20042fc001021bed7dfcf73684b05";
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "colemak";
  services.xserver.xkb.options = "caps:swapescape";

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sgower = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    home = "/home/sgower";
    shell = "/run/current-system/sw/bin/zsh";
    hashedPassword = "$y$j9T$.sU/2YffI0ehbsBFAVhA1/$CVOPL68OoS4vKXVQBv1gzCS30ou3ZJmz8G.l.hbQw8.";
    packages = with pkgs; [
    ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    tree
    zsh
    neovim
    git
    gcc14
    fzf
    ripgrep
    bat
    starship
    ghostty
    alacritty
    silver-searcher
    # nerd-fonts
    iosevka
    gnome-tweaks
    zellij
    signal-desktop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Firmware updates through LVFS
  services.fwupd.enable = true;

  system.stateVersion = "25.05";

  services.fprintd.enable = true;
  security.pam.services.sudo.fprintAuth = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
}
