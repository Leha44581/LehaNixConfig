{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

	# Looking for customizations?
	# Head to ./plasma-manager.nix

{
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

	# Essentials go down there \/
	services.xserver.enable = true;				# Enable the X11 windowing system

	services.displayManager.sddm.enable = true;	# Enable the KDE Plasma Desktop Environment.
	services.desktopManager.plasma6.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us,ru";
		variant = "";
		options = "grp:alt_shift_toggle, shift:breaks_caps";
	};

	# services.xserver.libinput.enable = true;	# Enable for touchpad support
}
