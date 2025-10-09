{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    blacklistedKernelModules = [
      "nouveau"
      "nvidiafb"
    ];
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme"];
      kernelModules = [
        "dm-snapshot"
        "cryptd"
        "thunderbolt"
        "usbhid"
        "joydev"
        "xpad"
        "amdgpu"
      ];
    };
    kernelModules = [
      "kvm-intel"
      "thunderbolt"
      "usbhid"
      "joydev"
      "xpad"
      "amdgpu"
    ];
    extraModulePackages = [];

    plymouth = {
      enable = false;
      theme = "bgrt";
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f482c8b2-5207-45ab-b776-f5e86dd460ec";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2159-BBFE";
    fsType = "vfat";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/5cb6cd96-7f2d-4380-803f-bccde9a8874e";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/e1792b40-1d52-4d31-a734-173c82d15dc9";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
