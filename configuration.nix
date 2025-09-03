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
		"${inputs.nixpkgs-unstable}/nixos/modules/services/networking/byedpi.nix"
	];

	disabledModules = [	# Needed for byedpi options to work, requires the line above in imports
		"services/networking/byedpi.nix"
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

		zapret = {	# DPI tool, for when VPN no work
			enable = true;
			package = pkgs.unstable.zapret;
			httpSupport = true;
			httpMode = "full";	# Can also be "first", changes whether DPI is active for the first packet of the session, or all packets
			udpSupport = false; # Change to True later (Not that easy, look it up)
			params = [	# Parameters, good to change sometimes, run "nix-shell -p zapret --command block" to check
				"--dpi-desync=fake,disorder2"
				"--dpi-desync-ttl=1"
				"--dpi-desync-autottl=2"
			 ];
		};

		byedpi = {	# Another DPI tool, if shit hits the fan
			enable = false;
			package = pkgs.unstable.byedpi;
			extraArgs = [
				"--split"
				"1"
				"--disorder"
				"3+s"
				"--mod-http=h,d"
				"--auto=torst"
				"--tlsrec"
				"1+s"
			];
		};

		syncthing = {				# Syncthing, for syncing stuff, runs on http://127.0.0.1:8384/
			enable = true;
			package = pkgs.unstable.syncthing;
			user = "${vars.primaryUser}";
			dataDir = "/home/${vars.primaryUser}/syncthing";
			#key = ;	#Needed for https instead of http, but i can't be bothered rn
			#cert = ;
			#overrideDevices = true;	# Override any device changes made through WebUI
			overrideFolders = true;	# Override any folder changes made through WebUI
			settings = {
				devices = {
					"MePhone" = { id = "AT7CLYE-PEGZMQH-ZIX5UVJ-B3LX2MS-JO2JLAA-LNUZ45J-CNGHK6P-YVOZGQD"; };
				};
				folders = {
					"MusicStuffs" = {
						path = "/home/${vars.primaryUser}/TheGreatArchive/MusicStuff";
						devices = [ "MePhone" ];
						type = "sendonly";	# Can be sendonly, receiveonly, sendreceive, receiveencrypted, pretty self explanatory
						ignorePerms = true;	# Don't sync file permissions
					};
				};
			};
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

	swapDevices = [ {		# Mount Swap partition
		device = "${vars.swapDevicePath}";
	} ];

	fileSystems."/mnt/backups" = {	# Mount hard drive i use for backups
		device = "${vars.backupDevicePath}";
		fsType = "btrfs"; # Filesystem type
		options = [
			"nofail"
			"x-gvfs-show"
		];
	};

	security.rtkit.enable = true;
	security.polkit.enable = true; # Needed for OBS Virtual Camera

	networking.hostName = "${vars.hostname}"; 	# Define your hostname.
	# networking.wireless.enable = true;		# Enables wireless support via wpa_supplicant.;

	networking.networkmanager.enable = true; 	# Enable Networking

	system.stateVersion = "${vars.stateVersion}";	# Starting version, do not change

}
