let
	vars = import ./variables.nix;
in
{
	description = "Flake!";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-${vars.stateVersion}";	# nixpkgs are special, and don't require the whole URL
	};

	outputs = { self, nixpkgs, ... }:
		let
			lib = nixpkgs.lib;
		in	{
			nixosConfigurations = {
				${vars.hostname} = lib.nixosSystem {
					system = "${vars.systemArchitecture}";
					modules = [ ./configuration.nix ];
				};
			};
		};
}
