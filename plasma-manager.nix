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
			taskbar = {
				height = 40;		# Taskbar height
				floating = false;	# Stops it from detaching, when no fullscreen apps are opened
				location = bottom;	# Taskbar location
				opacity = opaque;	# Taskbar transparency (can be set to opaque, adaptive, translucent)

				# Widgets that should appear on the taskbar
				# Some can be found with "find /nix/store -iname "*plasmoids*" " in the /share/plasma/plasmoids type directories
				# Specific ones can be found with "find /nix/store/*/share/plasma/plasmoids -iname "*string*""
				widgets = [
					"org.kde.plasma.kickoff"
					#"org.kde.plasma.pager"				# Switch between virtual desktops
					"org.kde.plasma.icontasks"
					"org.kde.plasma.marginsseparator"
					"org.kde.plasma.systemtray"
					"org.kde.plasma.digitalclock"		# Digital Clock, shows date and time
					"org.kde.plasma.showdesktop"
				];
			};
		];
	};
}
