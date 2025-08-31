{ config, pkgs, inputs, ... }:

let
	vars = import ./variables.nix;
in

{

	# Disabled modules, like, if you wanna replace a whole module with one from the unstable branch, should be included in imports, since one can't just disable a module
	disabledModules = [
		"services/video/wivrn.nix"
	];

	imports = [ # Include the results of the hardware scan and a bunch of other stuff
		"${inputs.nixpkgs-unstable}/nixos/modules/services/video/wivrn.nix"
	];

	programs = {
		alvr = {	# A VR thing
			enable = true;
			openFirewall = true;
			package = pkgs.unstable.alvr;
		};
	};

	# Services to enable
	services = {
		wivrn = {	# Another VR thing
			enable = true;
			openFirewall = true;
			autoStart = false; # Autostart service by default?
			#highPriority = false;
			defaultRuntime = false; # Should WiVRn be the default openXR runtime?
			package = pkgs.unstable.wivrn;
			steam.package = pkgs.unstable.steam;
			steam.importOXRRuntimes = true; # Needed for steam to automatically discover wivrn server
		};
	};
}
