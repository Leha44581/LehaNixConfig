{ config, pkgs, inputs, ... }:

let
	vars = import ./variables.nix;
in

{

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.${vars.primaryUser} = {
		isNormalUser = true;
		description = "${vars.primaryUser}";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	# Enable OpenSSH just in case :tm:
	# Even if this is not meant to be accessed remotely, or be any kind of server
	services = {
		openssh.enable = true;		# Enable OpenSSH | DO NOT TURN OFF
	};

	# Some VERY essential Programs
	programs = {
		nano.enable = false;			# Disable Nano (installed by default), yes removing it is necessary (i just don't like it)
		vim.enable = true;				# Vim Text Editor
		git.enable = true;				# CLI Version Management Utility
	};

	# Vim, it's included here, and not in packages.nix so you aren't left without a text editor if you fuck up
	environment.systemPackages = with pkgs; [

		# Vim config
		((vim_configurable.override {  }).customize{
			name = "vim";
			vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
				start = [ vim-nix vim-lastplace ];
				opt = [];
			};

			vimrcConfig.customRC = ''
				" Leha's vimrc
				set nocompatible
				set backspace=indent,eol,start

				" Sets tabsize to 4 spaces
				set tabstop=4

				" Suffixes that get lower priority when doing tab completion for filenames
				" These are files we are unlikely to want to edit or read
				set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

				syntax on

				colorscheme evening
			'';
		})
	];

	time.timeZone = "${vars.primaryUserTimezone}";	# Timezone

	i18n.defaultLocale = "en_US.UTF-8";	# Default Language

	i18n.extraLocaleSettings = {		# Other language settings
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_GB.UTF-8";
		LC_DATE = "en_GB.UTF-8";
	};

	i18n.extraLocales = [			# Extra Languages to install
		"all"
	];

	# Bootloader
	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
		extraModulePackages = with config.boot.kernelPackages; [
			v4l2loopback	# Needed for OBS Virtual Camera to work
		];
		# Also for OBS \/
		extraModprobeConfig = ''
			options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
		'';
	};
}
