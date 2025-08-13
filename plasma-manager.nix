{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	# This is where custom themes n stuff go
	home.packages = with pkgs; [
		catppuccin-kde
		whitesur-kde
	];

	programs.plasma = {

		enable = true;

		workspace = {
			lookAndFeel = "org.kde.breezedark.desktop";
		};
	};
}
