let
	vars = import ./variables.nix;
in

{
	stateVersion = "25.05";

	primaryUser = "leha44581";

	primaryUserGit = "leha44581";
	primaryUserEmail = "leha55481@gmail.com";

	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${vars.stateVersion}.tar.gz";
}
