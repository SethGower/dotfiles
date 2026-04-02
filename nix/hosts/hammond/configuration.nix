# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  sops-nix,
  ...
}: {
  imports = [
  ];

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops.defaultSopsFile = ../../secrets/hammond.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/home/sgower/.ssh/id_ed25519"];
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # This is the actual specification of the secrets.
  sops.secrets.hashedPasswordFile = {};

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.hardware.bolt.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For 32 bit applications
    extraPackages = with pkgs; [
    ];
    # For 32 bit applications
    extraPackages32 = with pkgs; [
    ];
  };

  hardware.openrazer = {
    enable = true;
    users = ["sgower"];
  };

  networking = {
    hostName = "hammond"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "colemak";
  services.xserver.xkb.options = "caps:swapescape";

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sgower = {
    isNormalUser = true;
    # wheel is to allow for sudo access
    extraGroups = ["wheel" "openrazer" "dialout" "plugdev" "docker"];
    description = "Seth Gower";
    home = "/home/sgower";
    shell = "/run/current-system/sw/bin/zsh";
    hashedPasswordFile = config.sops.secrets.hashedPasswordFile.path;
    packages = with pkgs; [
    ];
  };
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
      ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/addon/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "gt@giphy.com" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/addon/giphy-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

  # programs.element-desktop.enable = true;

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
    desktop-file-utils
    lact
    openrazer-daemon
    polychromatic
    pavucontrol
    killall
    amdgpu_top
    cifs-utils
    chromium
    gnome-tweaks
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

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

  services.protonmail-bridge = {
    enable = true;
    path = with pkgs; [pass gnome-keyring];
    package = pkgs.protonmail-bridge-gui;
  };

  services.mullvad-vpn.enable = true;

  # This udev rule allows for mutter (the window manager for GNOME) to properly
  # use the eGPU as the primary. When I was on Arch, I used all-ways-egpu,
  # which does this in the backend.
  # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1562 for more
  # info on this
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_minor", ENV{DEVNAME}=="/dev/dri/card[0-9]", SUBSYSTEMS=="pci", ATTRS{vendor}=="0x1002", ATTRS{device}=="0x73bf", TAG+="mutter-device-preferred-primary"
  '';

  sops.secrets.smb-secrets = {};

  # fileSystems."/mnt/media" = {
  #   # device = "//10.0.0.2/mnt/media";
  #   device = "10.0.0.2:/mnt/media";
  #   fsType = "nfs";
  #   # options = let
  #   #   # this line prevents hanging on network split
  #   #   automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #   #   ownership = "uid=${config.users.users.sgower.uid},gid=${config.users.users.sgower.gid}";
  #   #
  #   # in ["${automount_opts},credentials=${config.sops.secrets.smb-secrets.path}"];
  # };
  services.udisks2.enable = true;

  services.clamav = {
    clamonacc.enable = true;
    updater = {
      enable = true;
    };
    daemon = {
      enable = true;
    };
    scanner = {
      enable = false;
    };
  };

  hardware.keyboard.zsa.enable = true;

  # Echo cancellation, pulled from https://wiki.archlinux.org/title/PipeWire/Examples#Echo_cancellation
  # services.pipewire.extraConfig.pipewire."60-echo-cancel" = {
  #   "context.moudles" = [
  #     {
  #       name = "libpipewire-module-echo-cancel";
  #       args = {
  #         # Monitor mode: Instead of creating a virtual sink into which all
  #         # applications must play, in PipeWire the echo cancellation module can read
  #         # the audio that should be cancelled directly from the current fallback
  #         # audio output
  #         "monitor.mode" = true;
  #         "capture.props" = {
  #           # The audio source / microphone the echo should be cancelled from
  #           # Can be found with: pw-cli list-objects Node | grep node.name
  #           # Optional; if not specified the module uses/follows the fallback audio source
  #           # node.target = "alsa_input.usb-046d_HD_Pro_Webcam_C920_A2F94E5F-02.analog-stereo";
  #           # Passive node: Do not keep the microphone alive when this capture is idle
  #           "node.passive" = true;
  #           # Force quanatum of input stream in the graph
  #           # Fiddle with if experiencing voice distortion/crackling
  #           # Default: 0/unset
  #           #node.force-quantum = 256
  #         };
  #         # Output sink to be filtered from input
  #         # Can be found with: pw-cli list-objects Node | grep node.name
  #         # Optional; if not specified the module uses/follows the fallback audio source
  #         #sink.props = {
  #         # node.target = "alsa_output.usb-Audioengine_Audioengine_2_-00.iec958-stereo";
  #         #}
  #         "source.props" = {
  #           # The virtual audio source that provides the echo-cancelled microphone audio
  #           "node.name" = "source_ec";
  #           "node.description" = "Echo-cancelled source";
  #         };
  #         "aec.args" = {
  #           # Settings for the WebRTC echo cancellation engine
  #           # Gain control: On-the-fly microphone audio normalization
  #           # Default: false
  #           # Caution, the PipeWire WebRTC source code advises against enabling it:
  #           #  > Note: AGC seems to mess up with Agnostic Delay Detection, especially
  #           #  > with speech, result in very poor performance, disable by default
  #           #webrtc.gain_control = true
  #           # Extended filter: Widened audio delay window (?)
  #           # Default: true
  #           # Quote from the old source of the abandoned Mozilla Positron project (2016):
  #           #  > The extended filter mode gives us the flexibility to ignore the system's
  #           #  > reported delays. We do this for platforms which we believe provide results
  #           #  > which are incompatible with the AEC's expectations.
  #           # Suggestion: Turn it off unless required
  #           "webrtc.extended_filter" = false;
  #         };
  #       };
  #     }
  #   ];
  # };
}
