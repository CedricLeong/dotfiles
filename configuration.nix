{ config, pkgs, ... }:
[ configuration
				home-manager.darwinmodules.home-manager  {
					home-manager.useglobalpkgs = true;
					home-manager.useuserpackages = true;
					home-manager.verbose = true;
					home-manager.users.cleong = import ./home.nix; 
				} ]
