{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	# This is where custom themes n stuff go
	home.packages = with pkgs; [

		# Themes
		catppuccin
		catppuccin-kde

		# Widgets/plasmoids, bunch of stuff
		kdePackages.plasma-workspace
		kdePackages.plasma-desktop
	];

	programs.plasma = {

		enable = true;

		kwin.borderlessMaximizedWindows = false;	# Whether to remove/hide the border of maximized windows

		workspace = {
			lookAndFeel = "org.kde.breezedark.desktop";		# Global theme (see available with "plasma-apply-lookandfeel --list")

			wallpaper = "/etc/nixos/assets/JunosRoom_1080_Wallpaper.png";	# Wallpaper, can be set to an image file or a KPackage (whatever that means)
			# wallpaper = "/etc/nixos/assets/JunosRoom_original_4K_Wallpaper.png";	# Same Image but 4K
			wallpaperFillMode =	"preserveAspectCrop";		# Wallpaper Fill Mode, can be set to pat, preserveAspectCrop, preserveAspectFit, stretch, tile, tileHorizontally, tileVertically

			theme = null;									# Workspace theme (see availabe with "plasma-apply-desktoptheme --list-themes")

			splashScreen.theme = "Catppuccin-Frappe-Blue";	# Splash Screen theme, can be set to None to disable (see global themes for options)
			splashScreen.engine = null;						# Splash Screen engine, better left at null to let plasma figure it out
		};

		# Lock Screen Settings
		kscreenlocker = {
			lockOnResume = true;		# Lock the screen after sleep mode
			lockOnStartup = false;		# Lock the screen on startup
			passwordRequired = true;	# Whether the user password is required to unlock the screen
			passwordRequiredDelay = 5;	# The time it takes in seconds for the password to be required after the screen is locked
			timeout = 15;				# Timeout in minutes after which the screen will be locked

			# Visual Settings
			appearance = {
				alwaysShowClock = true;		# Whether to always show the clock on the lock screen, even if the unlock dialog isn't shown
				showMediaControls = true;	# Whether to show the media controls on the lock screen
				wallpaper = "/etc/nixos/assets/NixOS_Wallpaper_Catppuccin_Macchiato_Trans_Edit_Darkened.webp";	# Lock Screen Wallpaper
			};
		};

		# Panel settings
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
								"applications:PrusaSlicer.desktop"							# PrusaSlicer
								"applications:org.freecad.FreeCAD.desktop"					# FreeCAD
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
								"org.kde.plasma.cameraindicator"	# Camera indicator, lights up when the webcamera is being used
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

	programs.kate = {	# Kate Text Editor Settings

		editor = {		# Editing Settings

			tabWidth = 4;				# Width of each indent level in spaces for tab

			indent = {	# Indentation Settings

				width = 4;					# Width of each indent level in spaces
				replaceWithSpaces = false;	# Whether tabs should be converted to spaces
				backspaceDecreaseIndent = true;	# Whether backspace should always decrease indentation by a full level

				showLines = true;			# Whether to show the vertical lines that mark each indentation level
			};
		};
	};

	programs.okular = {
		general.obeyDrm = false;	# I HATE DRM
	};
}
