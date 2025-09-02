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

		libreoffice-fresh # A bunch of office apps

		android-tools	# Necessary for ALVR to work

		keepassxc		# Local Password Manager
		kpcli			# Keepass CLI tool

		discord			# Messenger
		revolt-desktop	# FOSS Discord Alternative
		fluffychat		# Matrix Chat Client
		#mautrix-discord	# Matrix-Discord Bridge
		#mautrix-telegram# Matrix-Telegram Bridge

		steam			# Game Distribution Platform
		steamcmd		# CLI version of steam
		
		yt-dlp			# CLI tool to download videos/music/etc. off the internet in bulk
		gallery-dl		# CLI tool to download image-galleries and collections from image-hosting sites
		ffmpeg-full		# CLI Media Editing Utility
		]

		++ (with pkgs; [

		# Stable packages
		kdePackages.kcalc	# Calculator
		unipicker			# Another Character Picker

		ungoogled-chromium	# Chromium (ew) for things that don't work in librewolf

		vlc				# Video and general media player
		strawberry		# Music player
		baobab			# Disk Usage Space Analyzer
		obsidian		# Markdown Note Taking app

		pinta 			# Lightweight Drawing and Image Editing tool
		gimp3			# Serious Image Editor

		wireplumber		# Needed for OBS plugins

		telegram-desktop	# Another messenger

		ckan			# KSP Mod Manager
		prismlauncher	# Minecraft Launcher
		pufferpanel		# Minecraft Server GUI

		deluge			# Torrent Client

		filezilla		# GUI FTP/SFTP/FTPS Client

		#ksnip			# Screenshot Capture Tool	DOESNT WORK

		gparted			# GUI Disk Partitioning tool

		flatpak			# Flatpak Package Manager
		flatpak-builder	# Flatpak Compiler

		syncthingtray	# Tray application for Syncthing

		fastfetch		# Just like neofetch!
		tldr			# Community driven man alternative
		coreutils-full	# GNU Core Utilities, the essentials
		stc-cli			# CLI Syncthing tool
		#metadata		# CLI Metadata parser for human consumption
		rsync			# CLI File Sync tool
		lvm2			# CLI LVM Partitioning tool
		unixtools.fdisk	# CLI Disk Partitioning tool
		networkmanager	# CLI-GUI Networking tool
		htop			# CLI-GUI System Monitor
		#gitui			# CLI-GUI for Git
		pciutils		# CLI Utils for hardware stuff i think?
		lsof			# CLI util to list open files
		nth				# CLI Hash Identification Utility
		bash			# Scripting Language
		python3Full		# Programming Language
		nodejs_20		# Another Programming Thing i need for the External Application Button browser extension to work

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
