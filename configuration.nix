{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  #Bootloader
  boot.loader = {
  	systemd-boot.enable = true;
  	efi.canTouchEfiVariables = false;
  	efi.efiSysMountPoint = "/boot";
  };

  #Network
  networking = {
  	hostName = "nixos";
  	networkmanager.enable = true;
  	firewall.enable = true;
  };

  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = true;

  #Graphics
  hardware = {
	graphics.enable = true;
	graphics.extraPackages = with pkgs; [
		intel-media-driver
		vpl-gpu-rt
	];
	nvidia = {
		open = true;
		modesetting.enable = true;
		powerManagement.enable = true;
		powerManagement.finegrained = true;
		prime.offload.enable = true;
		prime.offload.enableOffloadCmd = true;
		prime.intelBusId = "PCI:0:2:0";
		prime.nvidiaBusId = "PCI:1:0:0";
	};
  };

  #Audio, Video & Power Management
  powerManagement.enable = true;
  services = {
  	xserver = {
		enable = true;
		libinput.enable = true;
		videoDrivers = [ "modesetting" "nvidia" ];
	};
  	pipewire = {
  		enable = true;
  		alsa.enable = true;
  		alsa.support32Bit = true;
  		pulse.enable = true;
	};
	logind.settings.Login = {
		HandleLidSwitch = "suspend";
		HandleLidSwitchExternalPower = "suspend";
		HandleLidSwitchDocked = "ignore";
  	};
	desktopManager.plasma6.enable = true;
	displayManager.sddm.enable = true;	
  };

  #User management
  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  #Packages
  environment.systemPackages = with pkgs; [
    neovim
    fastfetch
    mission-center
    brave
  ];

  # system.copySystemConfiguration = true;
  system.stateVersion = "26.05";
}
