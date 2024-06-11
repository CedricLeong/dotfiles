{ config, pkgs, lib, ... }:
{
# this is internal compatibility configuration 
# for home-manager, don't change this!
	home.stateVersion = "23.05";
# Let home-manager install and manage itself.
	programs.home-manager.enable = true;

	home.packages = with pkgs; [];

	home.sessionVariables = {
		EDITOR = "nvim";
	};
	home.file.".vimrc".source = ./vim_configuration; 


	programs.zsh = {
		enable = true;
		shellAliases = {
			switch = "darwin-rebuild switch --flake ~/nix-darwin-config/";
		};
	};
	programs.git = {
		enable = true;
		userName = "cedric leong";
		userEmail = "cedricleong@gmail.com";
		ignores = [ ".DS_Store" ];
		extraConfig = {
			init.defaultBranch = "main";
			push.autoSetupRemote = true;
		};
	};
	programs.vim = {
		enable = true;
		plugins = with pkgs.vimPlugins; [ vim-airline ];
		settings = { ignorecase = true; };
		extraConfig = ''
			set mouse=a
			'';
	};
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;
		plugins = with pkgs.vimPlugins; [
			nvim-lspconfig
				nvim-treesitter.withAllGrammars
				plenary-nvim
				gruvbox-material
				mini-nvim
				telescope-nvim
				tokyonight-nvim
				vim-floaterm
				gitsigns-nvim
		];
		extraConfig = lib.fileContents ./vim_configuration;
	};
}
