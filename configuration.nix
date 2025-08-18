{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			./kde_plasma.nix
			./packages.nix
			./scripts.nix
			./nvigia.nix
		];

	nix.settings.experimental-features = [ "nix-command" "flakes"]; # Enable flakes

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.${vars.primaryUser} = {
		isNormalUser = true;
		description = "${vars.primaryUser}";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	# Programs
	programs = {
		nano.enable = false;			# Disable Nano (installed by default)
		vim.enable = true;				# Vim Text Editor
		amnezia-vpn.enable = true;		# AmneziaVPN Client
		firefox.enable = false;			# Firefox Web Browser
		gamemode.enable = true;			# Lets you optimize system performance on demand, add gamemoderun %command% to steam launch options to use
		steam = {						# Game Distribution platform
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			localNetworkGameTransfers.openFirewall = true;
		};

		git.enable = true;				# CLI Version Management Utility
	};


	# Vim, it's included here, and not in packages.nix so you aren't left without a text editor if you fuck up
	environment.systemPackages = with pkgs; [

		# Vim config
		((vim_configurable.override {  }).customize{
			name = "vim";
			vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
				start = [ vim-nix vim-lastplace ];
				opt = [];
			};

			vimrcConfig.customRC = ''
				" Leha's vimrc
				set nocompatible
				set backspace=indent,eol,start
				
				" Sets tabsize to 4 spaces
				set tabstop=4 
				
				" Suffixes that get lower priority when doing tab completion for filenames
				" These are files we are unlikely to want to edit or read
				set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg
				
				syntax on
				
				colorscheme evening
			'';
		})
	];

	# Services to enable
	services = {
		openssh.enable = true;		# Enable OpenSSH | DO NOT TURN OFF
		flatpak.enable = true;		# Flatpak
		printing.enable = true;		# CUPS for printing stuff

		# Sound Stuffs DO NOT CHANGE
		pulseaudio.enable = false;
		pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		};
	};

	nix.optimise = {		# Storage optimizer, replaces same files with hard links every week
		automatic = true;
		dates = [ "weekly" ];
	};

	swapDevices = [ {
		device = "${vars.swapDevicePath}";
	} ];

	time.timeZone = "${vars.primaryUserTimezone}"; 			# Timezone

	i18n.defaultLocale = "en_US.UTF-8";			# Default Language

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_GB.UTF-8";
		LC_DATE = "en_GB.UTF-8";
	};

	i18n.extraLocales = [						# Extra Languages to install
		"all"
	];

	# Enable sound with pipewire.
	security.rtkit.enable = true;

	networking.hostName = "${vars.hostname}"; 	# Define your hostname.
	# networking.wireless.enable = true;		# Enables wireless support via wpa_supplicant.;

	networking.networkmanager.enable = true; 	# Enable Networking

	boot.loader.systemd-boot.enable = true;		# Bootloader
	boot.loader.efi.canTouchEfiVariables = true;

	system.stateVersion = "${vars.stateVersion}";	# Starting version, do not change

}
