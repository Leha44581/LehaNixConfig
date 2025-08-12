{
	description = "Flake!";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
	#	home-manager = "github:nix-community/home-manager/release-25.05";
	};

	outputs = { self, nixpkgs, ... }@inputs:
		let
			lib = nixpkgs.lib;
			vars = import ./variables.nix;
		in
		{
			nixosConfigurations = {
				${vars.hostname} = lib.nixosSystem {
					system = "${vars.systemArchitecture}";
					modules = [ ./configuration.nix ];
				};
			};
		};
}
