{
	description = "Flake!";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager= {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";	# Follow nixpkgs version
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs:
		let
			lib = nixpkgs.lib;
			vars = import ./variables.nix;
		in
		{
			nixosConfigurations = {
				${vars.hostname} = lib.nixosSystem {
					system = "${vars.systemArchitecture}";
					modules = [
						./configuration.nix

						home-manager.nixosModules.home-manager	#define home-manager as nix module
						{
							home-manager.useUserPackages = true;
							home-manager.useGlobalPkgs = true;
							home-manager.backupFileExtension = "bak";
							home-manager.users.${vars.primaryUser} = import ./home.nix;
						}
					];
				};
			};
		};
}
