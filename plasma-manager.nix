{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	# This is where custom themes n stuff go
	home.packages = with pkgs; [

		# Themes
		catppuccin-kde
		whitesur-kde

		# Widgets/plasmoids, bunch of stuff
		kdePackages.plasma-workspace
		kdePackages.plasma-desktop
	];

	programs.plasma = {

		enable = true;

		workspace = {
			lookAndFeel = "org.kde.breezedark.desktop";	# Global theme (see available with "plasma-apply-lookandfeel --list")
		};

		# Taskbar settings
		panels = [
			{	# Taskbar settings
				height = 40;			# Taskbar height
				minLength = 1000;		# Taskbar Minimal Width
				maxLength = null;		# Taskbar Maximal Width
				lengthMode = "fill";	# Taskbar Width Mode (can be set to fit, fill, custom)
				floating = false;		# Stops it from detaching, when no fullscreen apps are opened
				location = "bottom";	# Taskbar location
				opacity = "opaque";		# Taskbar transparency (can be set to opaque, adaptive, translucent)
				hiding = "none";		# Taskbar behaviour when covered by windows (can be set to none, autohide, dodgewindows, windowsgobelow, normalpanel)

				# Widgets that should appear on the taskbar
				# Some can be found with "find /nix/store -iname "*plasmoids*" " in the /share/plasma/plasmoids type directories
				# Specific ones can be found with "find /nix/store/*/share/plasma/plasmoids -iname "*string*""
				widgets = [

					{	# Kickoff settings (start menu icon)
						kickoff = {
							icon = "nix-snowflake-white";
						};
					}

					{	# Task Icons, this is the flesh of the taskbar, without it, all widgets move to the left
						# Specific ones can be found with "find /nix/store/*/share/applications -iname "*string*""
						iconTasks = {
							launchers = [
								"applications:org.kde.konsole.desktop"						# Console/Shell
								"applications:org.kde.dolphin.desktop"						# File Manager
								"applications:org.kde.plasma-systemmonitor.desktop"			# System Monitor
								"applications:com.obsproject.Studio.desktop"				# OBS Studio
								"applications:discord.desktop"								# Discord
								"applications:steam.desktop"								# Steam
								"applications:firefox.desktop"								# Firefox
								"applications:AmneziaVPN.desktop"							# Amnezia VPN
								"applications:obsidian.desktop"								# Obsidian
								"applications:org.strawberrymusicplayer.strawberry.desktop"	# Strawberry Music Player
								"applications:org.prismlauncher.PrismLauncher.desktop"		# Prism Launcher
								"applications:org.telegram.desktop.desktop"					# Telegram Desktop
							];
						};
					}

					"org.kde.plasma.marginsseparator"	# Margin Separator

					{	# System Tray, contains things like sound/networking/keyboard language/brightness/etc.
						# Some can be found with "find /nix/store -iname "*plasmoids*" " in the /share/plasma/plasmoids type directories
						# Specific ones can be found with "find /nix/store/*/share/plasma/plasmoids -iname "*string*""
						systemTray.items = {
							shown = [
								"org.kde.plasma.networkmanagement"
								"org.kde.plasma.volume"
								"org.kde.plasma.layout"	# Keyboard Layout
							];

							hidden = [
								"org.kde.plasma.battery"
								"org.kde.plasma.bluetooth"
								"org.kde.plasma.clipboard"
								"org.kde.plasma.brightness"
								"org.kde.plasma.devicenotifier" # Device Notifier (notifies about removable devices)
							];
						};
					}

					"org.kde.plasma.digitalclock"		# Digital Clock, shows date and time
					#"org.kde.plasma.pager"				# Switch between virtual desktops
					#"org.kde.plasma.showdesktop"
				];
			}
		];
	};
}
