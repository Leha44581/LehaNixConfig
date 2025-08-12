{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	programs.plasma = {

		enable = true;

		workspace = {
			lookAndFeel = "org.kde.breezedark.desktop";
		};
	};
}
