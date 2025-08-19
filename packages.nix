{ config, pkgs, inputs, ... }:

let
	vars = import ./variables.nix;
in

	# This is where one specifies all the packages
	# If it's installed, but not here, then it comes from Programs, or NixOS/DE Defaults

{
	# This overlay allows to pull from unstable repo with pkgs.unstable
	nixpkgs.overlays = [
		(final: prev: {
			unstable = import inputs.nixpkgs-unstable {
				system = "${vars.systemArchitecture}";
				config.allowUnfree = true;
			};
		})
	];

	nixpkgs.config.allowUnfree = true;	

	environment.systemPackages = with pkgs.unstable; [

		# Unstable packages, Latest and Greatest
		blender			# 3D Art Program
		freecad			# 3D CAD Program
		prusa-slicer	# 3D Print Slicer

		alvr			# A VR thing
		sidequest		# Another VR thing
		android-tools	# Necessary for ALVR to work

		discord			# Messenger

		steam			# Game Distribution Platform
		steamcmd		# CLI version of steam

		yt-dlp			# CLI tool to download videos/music/etc. off the internet in bulk
		]

		++ (with pkgs; [

		# Stable packages
		kdePackages.kcalc	# Calculator
		unipicker			# Another Character Picker

		vlc				# Video and general media player
		strawberry		# Music player
		baobab			# Disk Usage Space Analyzer
		obsidian		# Markdown Note Taking app

		pinta 			# Lightweight Drawing and Image Editing tool
		gimp3			# Serious Image Editor

		wireplumber		# Needed for OBS plugins

		telegram-desktop	# Another messenger

		amnezia-vpn		# Amnezia VPN Client

		librewolf		# Web Browser

		ckan			# KSP Mod Manager
		prismlauncher	# Minecraft Launcher
		pufferpanel		# Minecraft Server GUI

		deluge			# Torrent Client

		filezilla		# GUI FTP/SFTP/FTPS Client

		#ksnip			# Screenshot Capture Tool	DOESNT WORK
		obs-studio		# Video Recording and Live Streaming app

		gparted			# GUI Disk Partitioning tool

		flatpak			# Flatpak Package Manager
		flatpak-builder	# Flatpak Compiler

		fastfetch		# Just like neofetch!
		tldr			# Community driven man alternative
		rsync			# CLI File Sync tool
		lvm2			# CLI LVM Partitioning tool
		unixtools.fdisk	# CLI Disk Partitioning tool
		networkmanager	# CLI-GUI Networking tool
		htop			# CLI-GUI System Monitor
		#gitui			# CLI-GUI for Git
		pciutils		# CLI Utils for hardware stuff i think?
		lsof			# CLI util to list open files
		bash			# Scripting Language

		#nerd-fonts.m+	# All the nerd fonts :3
		material-design-icons
		#nerd-fonts.noto
		#nerd-fonts.hack
		#nerd-fonts.tinos
		#nerd-fonts.lilex
		#nerd-fonts.arimo
		#nerd-fonts.agave
		#nerd-fonts._3270
		nerd-fonts.ubuntu
		#nerd-fonts.monoid
        #nerd-fonts.lekton
        #nerd-fonts.hurmit
        #nerd-fonts.profont
        #nerd-fonts.monofur
        #nerd-fonts.iosevka
        #nerd-fonts.hasklug
        #nerd-fonts.go-mono
        #nerd-fonts.cousine
        nerd-fonts.zed-mono
        nerd-fonts.overpass
        nerd-fonts.mononoki
        nerd-fonts.gohufont
        nerd-fonts.d2coding
        nerd-fonts._0xproto
        #nerd-fonts.monaspace
        nerd-fonts.fira-mono
        nerd-fonts.fira-code
        nerd-fonts.blex-mono
        nerd-fonts.anonymice
        nerd-fonts.space-mono
        nerd-fonts.liberation
        nerd-fonts.im-writing
        nerd-fonts.heavy-data
        nerd-fonts.geist-mono
        nerd-fonts.victor-mono
        #nerd-fonts.ubuntu-sans
        #nerd-fonts.ubuntu-mono
        nerd-fonts.roboto-mono
        nerd-fonts.intone-mono
        nerd-fonts.inconsolata
        nerd-fonts.envy-code-r
        nerd-fonts.commit-mono
        nerd-fonts.symbols-only
        nerd-fonts.martian-mono
        nerd-fonts.iosevka-term
        nerd-fonts.adwaita-mono
        nerd-fonts.terminess-ttf
        nerd-fonts.open-dyslexic
	]);
}
