# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			(import "${vars.home-manager}/nixos")
		];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.;

	networking.networkmanager.enable = true; 	# Enable Networking

	time.timeZone = "Europe/Moscow"; 			# Timezone

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
		LC_TIME = "en_US.UTF-8";
	};
	
	i18n.extraLocales = [						# Extra Languages to install
		"all"
	];

	services.xserver.enable = true;				# Enable the X11 windowing system

	services.displayManager.sddm.enable = true;	# Enable the KDE Plasma Desktop Environment.
	services.desktopManager.plasma6.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us,ru";
		variant = "";
		options = "grp:alt_shift_toggle, shift:breaks_caps";
	};

	services.printing.enable = true;		# Enable CUPS for printing stuff

	# Enable sound with pipewire.
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	# services.xserver.libinput.enable = true;	# Enable for touchpad support

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.${vars.primaryUser} = {
		isNormalUser = true;
		description = "${vars.primaryUser}";
		extraGroups = [ "networkmanager" "wheel" ];

	# User Specific Packages
		packages = with pkgs; [
		#	kdePackages.kate
		#	thunderbird
		];
	};

	home-manager.useUserPackages = true;
	home-manager.useGlobalPkgs = true;
	home-manager.backupFileExtension = "bak";
	home-manager.users.${vars.primaryUser} = import ./home.nix;

	# Programs
	programs = {
		nano.enable = false;			# Disable Nano (installed by default)
		vim.enable = true;				# Vim Text Editor
		firefox.enable = true;			# Firefox Web Browser
		steam = {						# Game Distribution platform
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			localNetworkGameTransfers.openFirewall = true;
		};

		git.enable = true;				# CLI Version Management Utility
	};


	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
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

		kdePackages.kcalc	# Calculator

		vlc				# Video and general media player
		strawberry		# Music player
		baobab			# Disk Usage Space Analyzer
		obsidian		# Markdown Note Taking app

		pinta 			# Lightweight Drawing and Image Editing tool
		gimp3			# Serious Image Editor

		blender			# 3D Art Program

		discord			# Messenger
		telegram-desktop	# Another messenger

		steamcmd		# CLI version of steam

		amnezia-vpn		# Amnezia VPN Client

		prismlauncher	# Minecraft Launcher

		deluge			# Torrent Client

		filezilla		# GUI FTP/SFTP/FTPS Client

		ksnip			# Screenshot Capture Tool
		obs-studio		# Video Recording and Live Streaming app

		gparted			# GUI Disk Partitioning tool

		rsync			# CLI File Sync tool
		unixtools.fdisk	# CLI Disk Partitioning tool
		networkmanager	# CLI-GUI Networking tool
		gitui			# CLI-GUI for Git
	];

	# Remove KDE Plasma default apps
	environment.plasma6.excludePackages = [
		# pkgs.kdePackages.konsole				# Shell Console Emulator
		# pkgs.kdePackages.ark					# Archiving tool
		pkgs.kdePackages.elisa				# Music Player
		# pkgs.kdePackages.gwenview				# Image Viewer
		# pkgs.kdePackages.okular				# Document Viewer
		# pkgs.kdePackages.kate					# Text Editor
		# pkgs.kdePackages.khelpcenter			# KDE Help Center
		# pkgs.kdePackages.dolphin				# File Manager
		# pkgs.kdePackages.baloo-widgets		# Baloo Widgets for Dolphin
		# pkgs.kdePackages.dolphin-plugins		# Dolphin Plugins
		pkgs.kdePackages.spectacle			# Screenshot Capture Utility
		# pkgs.kdePackages.ffmpegthumbs
		# pkgs.kdePackages.krdp					# Remote Desktop
		# pkgs.kdePackages.xwaylandvideobridge
	];
	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#	 enable = true;
	#	 enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "${vars.stateVersion}"; # Did you read the comment?

}
