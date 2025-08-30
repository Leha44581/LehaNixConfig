{ config, pkgs, inputs, ... }:

let
	vars = import ./variables.nix;
in

{

	# Disabled modules, like, if you wanna replace a whole module with one from the unstable branch, should be included in imports, since one can't just disable a module
	disabledModules = [
		"services/video/wivrn.nix"
	];

	imports = [ # Include the results of the hardware scan and a bunch of other stuff
		./hardware-configuration.nix
		./kde_plasma.nix
		./packages.nix
		./scripts.nix
		./nvidia.nix
		"${inputs.nixpkgs-unstable}/nixos/modules/services/video/wivrn.nix"
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
		firefox = {						# Librewolf Web Browser
			enable = true;
			package = pkgs.librewolf;
			policies = {
				DisableTelemetry = true;
				DisableFirefoxStudies = true;
				Preferences = {
					"cookiebanners.service.mode" = 2;	# Block cookie banners
					"cookiebanners.service.mode.privateBrowsing" = 2;
					"privacy.donottrackheader.enabled" = true;
					"privacy.fingerprintingProtection" = true;
					"privacy.resistFingerprinting" = true;
					"privacy.trackingprotection.enabled" = true;
					"privacy.trackingprotection.emailtracking.enabled" = true;
					"privacy.trackingprotection.fingerprinting.enabled" = true;
					"privacy.trackingprotection.socialtracking.enabled" = true;
					"widget.use-xdg-desktop-portal.file-picker" = 1;	# Use Dolphin as the default file manager
				};
				# Extension ID can be found at about:debugging#/runtime/this-firefox
				# This is a URL /\
				ExtensionSettings = {	# Addon Parameters
					"uBlock0@raymondhill.net" = {	# Ublock Origin
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
						installation_mode = "force_installed";
	  				};
					"jid1-MnnxcxisBPnSXQ@jetpack" = {	# Privacy Badger
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
						installation_mode = "force_installed";
					};
					"addon@darkreader.org" = {	 	# Dark Reader
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
						installation_mode = "force_installed";
					};
					"sponsorBlocker@ajay.app" = {	# Sponsorblock
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
						installation_mode = "force_installed";
					};
					"dearrow@ajay.app" = {			# Dearrow
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
						installation_mode = "force_installed";
					};
					"user-agent-switcher@ninetailed.ninja" = {	# User Agent Switcher
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
						installation_mode = "force_installed";
					};
					"Tab-Session-Manager@sienoru" = {			# Tab Session Manager
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
						installation_mode = "force_installed";
					};
					"{cb31ec5d-c49a-4e5a-b240-16c767444f62}" = {	# Indie Wiki Buddy
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/indie-wiki-buddy/latest.xpi";
						installation_mode = "force_installed";
					};
					"{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {	# Return Youtube Dislike
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislike/latest.xpi";
						installation_mode = "force_installed";
					};
				};
			};
		};
		thunderbird.enable = true;
		gamemode.enable = true;			# Lets you optimize system performance on demand, add gamemoderun %command% to steam launch options to use
		steam = {						# Game Distribution platform
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			localNetworkGameTransfers.openFirewall = true;
		};
		
		obs-studio = {					# Video Recording and Live Streaming app
			enable = true;
			plugins = with pkgs.obs-studio-plugins; [
				obs-pipewire-audio-capture	# Application Audio Capture
				obs-backgroundremoval
			];
		};

		git.enable = true;				# CLI Version Management Utility
		
		alvr = {	# A VR thing
			enable = true;
			openFirewall = true;
			package = pkgs.unstable.alvr;
		};	
	};

	# Switch firefox policies to librewolf
	environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

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
	
		wivrn = {	# Another VR thing
			enable = true;
			openFirewall = true;
			autoStart = false; # Autostart service by default?
			#highPriority = false;
			defaultRuntime = false; # Should WiVRn be the default openXR runtime?
			package = pkgs.unstable.wivrn;
			steam.package = pkgs.unstable.steam;
			steam.importOXRRuntimes = true; # Needed for steam to automatically discover wivrn server
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

	security.rtkit.enable = true;
	security.polkit.enable = true; # Needed for OBS Virtual Camera

	networking.hostName = "${vars.hostname}"; 	# Define your hostname.
	# networking.wireless.enable = true;		# Enables wireless support via wpa_supplicant.;

	networking.networkmanager.enable = true; 	# Enable Networking

	# Bootloader
	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
		extraModulePackages = with config.boot.kernelPackages; [
			v4l2loopback	# Needed for OBS Virtual Camera to work
		];
		# Also for OBS \/
		extraModprobeConfig = ''
			options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
		'';
	};

	system.stateVersion = "${vars.stateVersion}";	# Starting version, do not change

}
