{
	description = "Flake!";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager= {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";	# Follow nixpkgs version
		};

		plasma-manager = {
			url = "github:nix-community/plasma-manager/trunk";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, ... }:
		let
			lib = nixpkgs.lib;
			vars = import ./variables.nix;
		in
		{
			nixosConfigurations = {
				${vars.hostname} = lib.nixosSystem {
					specialArgs = {inherit inputs; };	# <- This is needed for unstable packages to work
					system = "${vars.systemArchitecture}";
					modules = [
						./configuration.nix

						home-manager.nixosModules.home-manager	#define home-manager as nix module
						{
							home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

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
