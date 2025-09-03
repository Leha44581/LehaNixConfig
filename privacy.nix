{ config, pkgs, inputs, ... }:

let
	vars = import ./variables.nix;
in

{
	disabledModules = [	# Needed for byedpi options to work, requires the corresponding line in imports
		"services/networking/byedpi.nix"
	];

	imports = [
		"${inputs.nixpkgs-unstable}/nixos/modules/services/networking/byedpi.nix"
	];

	programs = {
		amnezia-vpn.enable = true;		# AmneziaVPN Client
	};

	services = {

		zapret = {	# DPI tool, for when VPN no work
			enable = true;
			package = pkgs.unstable.zapret;
			httpSupport = true;
			httpMode = "full";	# Can also be "first", changes whether DPI is active for the first packet of the session, or all packets
			udpSupport = false; # Change to True later (Not that easy, look it up)
			params = [	# Parameters, good to change sometimes, run "nix-shell -p zapret --command block" to check
				"--dpi-desync=fake,disorder2"
				"--dpi-desync-ttl=1"
				"--dpi-desync-autottl=2"
			 ];
		};

		byedpi = {	# Another DPI tool, if shit hits the fan
			enable = false;
			package = pkgs.unstable.byedpi;
			extraArgs = [
				"--split"
				"1"
				"--disorder"
				"3+s"
				"--mod-http=h,d"
				"--auto=torst"
				"--tlsrec"
				"1+s"
			];
		};

	};
}
