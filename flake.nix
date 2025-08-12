{
	description = "Flake!";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.05";	# nixpkgs are special, and don't require the whole URL
	};

	outputs = { self, nixpkgs, ... }:
		let
			lib = nixpkgs.lib;
			vars = import ./variables.nix;
		in	{
			nixosConfigurations = {
				${vars.hostname} = lib.nixosSystem {
					system = "${vars.systemArchitecture}";
					modules = [ ./configuration.nix ];
				};
			};
		};
}
