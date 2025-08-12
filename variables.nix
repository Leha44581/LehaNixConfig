let
	vars = import ./variables.nix;
in

{
	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	stateVersion = "25.05";

	systemArchitecture = "x86_64-linux";

	hostname = "nixos-machine";

	primaryUser = "leha44581";
	primaryUserTimezone = "Europe/Moscow";
	primaryUserGit = "leha44581";
	primaryUserEmail = "leha55481@gmail.com";

	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${vars.stateVersion}.tar.gz";
}
