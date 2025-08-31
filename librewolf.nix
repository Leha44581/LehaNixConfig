{ config, pkgs, inputs, ... }:


let # This is technically not even needed here
	vars = import ./variables.nix;
in

{
	programs = {
		firefox = {	# Librewolf Web Browser
			enable = true;
			package = pkgs.librewolf;
			policies = {
				DisableTelemetry = true;
				DisableFirefoxStudies = true;
				Preferences = {
					"cookiebanners.service.mode" = 2;	# Block cookie banners
					"cookiebanners.service.mode.privateBrowsing" = 2;
					"privacy.donottrackheader.enabled" = true;
					"privacy.fingerprintingProtection" = true;
					"privacy.resistFingerprinting" = true;
					"privacy.trackingprotection.enabled" = true;
					"privacy.trackingprotection.emailtracking.enabled" = true;
					"privacy.trackingprotection.fingerprinting.enabled" = true;
					"privacy.trackingprotection.socialtracking.enabled" = true;
					"widget.use-xdg-desktop-portal.file-picker" = 1;	# Use Dolphin as the default file manager
				};
				# Extension ID can be found at about:debugging#/runtime/this-firefox
				# This is a URL /\
				ExtensionSettings = {	# Addon Parameters
					"uBlock0@raymondhill.net" = {					# Ublock Origin
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
						installation_mode = "force_installed";
	  				};
					"jid1-MnnxcxisBPnSXQ@jetpack" = {				# Privacy Badger
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
						installation_mode = "force_installed";
					};
					"addon@darkreader.org" = {	 					# Dark Reader
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
						installation_mode = "force_installed";
					};
					"sponsorBlocker@ajay.app" = {					# Sponsorblock
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
						installation_mode = "force_installed";
					};
					"dearrow@ajay.app" = {							# Dearrow
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
						installation_mode = "force_installed";
					};
					"user-agent-switcher@ninetailed.ninja" = {		# User Agent Switcher
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
						installation_mode = "force_installed";
					};
					"Tab-Session-Manager@sienoru" = {				# Tab Session Manager
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
						installation_mode = "force_installed";
					};
					"{cb31ec5d-c49a-4e5a-b240-16c767444f62}" = {	# Indie Wiki Buddy
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/indie-wiki-buddy/latest.xpi";
						installation_mode = "force_installed";
					};
					"{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {	# Return Youtube Dislike
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislike/latest.xpi";
						installation_mode = "force_installed";
					};
				};
			};
		};
	};
}
