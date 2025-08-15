{ config, pkgs, ... }:

let
	vars = import ./variables.nix;
in

{
	imports = [
		./plasma-manager.nix
	];

	home.username = "${vars.primaryUser}";
	home.homeDirectory = "/home/${vars.primaryUser}";
	home.stateVersion = "${vars.stateVersion}";

	programs = {

		fastfetch = {
			enable = true;
			settings = (builtins.fromJSON (builtins.readFile ./dotfiles/fastfetch.jsonc));	# Read file as string, convert the string into proper values
		};

		git = {
			enable = true;
			userName = "vars.${vars.primaryUserGit}";
			userEmail = "vars.${vars.primaryUserEmail}";
		};
	};

	home.packages = with pkgs; [
		# This is where you can install user-specific packages (don't do that (i don't like it))
	];
}
