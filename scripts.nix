{ config, pkgs, lib, ... }:

	# For some reason, you need to wrap scripts in this writeShellApplication bullshit, to actually run them, i hate this :(

let
	trim-generations-sh = pkgs.writeShellApplication {	# Garbage Collector packaging
		name = "trim-generations-sh";
		text = (builtins.readFile ./scripts/trim-generations.sh);
		runtimeInputs = [ pkgs.nix pkgs.bash pkgs.coreutils pkgs.gnused ]; # Packages that provide all the executables/commands used by the script
	 };

	tldrCacheUpdater = pkgs.writeShellApplication {	# tldr cache updater packaging
		name = "tldrCacheUpdated";
		text = '' printf "\n" && tldr -u && printf "\n"  '';	# printf to insert linebreaks before and after the command
		runtimeInputs = [ pkgs.bash pkgs.tldr ];
	};

	 vars = import ./variables.nix;
in

{
	# Scripts that run every boot, and every rebuild
	# Be careful with these
	system.activationScripts = {

		# Garbage Collector, deletes everything other than the last ${vars.nixGenKeep} generations
		garbageCollector = {
			text = ''
				${lib.getExe trim-generations-sh} ${vars.nixGenKeep} 0 system
			'';

			deps = [];	# Not package dependecies, other activation scripts go here, that must execute before this one
		};

		# Update cache for the tldr command
		tldrCacheUpdater = {
			text = '' ${lib.getExe tldrCacheUpdater} '';
		};
	};
}
