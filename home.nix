{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	home.username = "${vars.primaryUser}";
	home.homeDirectory = "/home/${vars.primaryUser}";
	home.stateVersion = "${vars.stateVersion}";

	programs.git = {
		enable = true;
		userName = "vars.${vars.primaryUserGit}";
		userEmail = "vars.${vars.primaryUserEmail}";
	};

	home.packages = with pkgs; [
		# This is where you can install user-specific packages (don't do that (i don't like it))
	];
}
