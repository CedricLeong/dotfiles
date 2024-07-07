{ description = "Example Darwin system flake"; inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs , home-manager }:
		let
		configuration = { pkgs, ... }: {
# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
			environment.systemPackages =
				[ pkgs.vim pkgs.neofetch pkgs.neovim
				pkgs.act
				];
# Auto upgrade nix package and the daemon service.
			services.nix-daemon.enable = true;
# nix.package = pkgs.nix;

# Necessary for using flakes on this system.
			nix.settings.experimental-features = "nix-command flakes";

# Create /etc/zshrc that loads the nix-darwin environment.
			programs.zsh.enable = true;
# programs.fish.enable = true;


# Set Git commit hash for darwin-version.
			system.configurationRevision = self.rev or self.dirtyRev or null;

# Used for backwards compatibility, please read the changelog before changing.
# $ darwin-rebuild changelog
			system.stateVersion = 4;

# The platform the configuration will be used on.
			nixpkgs.hostPlatform = "aarch64-darwin";

			security.pam.enableSudoTouchIdAuth = true;

			users.users.cleong = {
				name = "cleong";
				home = "/Users/cleong";
			};
		};
	in
	{
# Build darwin flake using:
# $ darwin-rebuild build --flake .#Cedrics-MacBook-Pro-2
		darwinConfigurations."Cedrics-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
			modules = [ configuration
				home-manager.darwinModules.home-manager  {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.verbose = true;
					home-manager.users.cleong = import ./home.nix; 
				} ];
		};

# Expose the package set, including overlays, for convenience.
		darwinPackages = self.darwinConfigurations."Cedrics-MacBook-Pro-2".pkgs;
	};
}
