{ config, pkgs, lib, ... }:

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

		# Create some empty folders
	home.activation.folders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		mkdir /home/${vars.primaryUser}/Stuff &&
		mkdir /home/${vars.primaryUser}/Stuff/Steam &&
		mkdir /home/${vars.primaryUser}/Stuff/SteamLibrary
	'';

	home.file = {
		# Make symlink from steam's default library to $HOME/SteamLibrary
		".local/share/Steam".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.primaryUser}/Stuff/Steam";
		"Stuff/Steam/steamapps/common".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.primaryUser}/Stuff/SteamLibrary";
	};

	home.packages = with pkgs; [
		# This is where you can install user-specific packages (don't do that (i don't like it))
	];
}
