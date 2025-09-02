{ config, pkgs, inputs, ... }:

let
	vars = import ./variables.nix;
in

{

	imports = [ # Include the results of the hardware scan and a bunch of other stuff
		./hardware-configuration.nix
		./essentials.nix
		./kde_plasma.nix
		./packages.nix
		./scripts.nix
		./nvidia.nix
		./vr.nix
		./librewolf.nix
	];

	# Programs
	programs = {
		amnezia-vpn.enable = true;		# AmneziaVPN Client
		thunderbird.enable = true;		# Thunderbird Mail Client
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
	};

	# Services to enable
	services = {
		flatpak.enable = true;		# Flatpak, yes i know it's imperative, it's also very convenient, just in case
		printing.enable = true;		# CUPS for printing stuff

		syncthing = {				# Syncthing, for syncing stuff
			enable = true;
			package = pkgs.unstable.syncthing;
			user = "${vars.primaryUser}";
		};

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

	security.rtkit.enable = true;
	security.polkit.enable = true; # Needed for OBS Virtual Camera

	networking.hostName = "${vars.hostname}"; 	# Define your hostname.
	# networking.wireless.enable = true;		# Enables wireless support via wpa_supplicant.;

	networking.networkmanager.enable = true; 	# Enable Networking

	system.stateVersion = "${vars.stateVersion}";	# Starting version, do not change

}
