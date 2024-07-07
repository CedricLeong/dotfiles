{ config, pkgs, lib, ... }:
{
# this is internal compatibility configuration 
# for home-manager, don't change this!
	home.stateVersion = "23.05";
# Let home-manager install and manage itself.
	programs.home-manager.enable = true;

	home.packages = with pkgs; [ 
		pkgs.ripgrep 
		pkgs.neovim-remote
	];

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
				nvim-treesitter-context
				plenary-nvim
				gruvbox-material
				mini-nvim
				telescope-nvim
				vim-floaterm
				tokyonight-nvim
				gitsigns-nvim
				nui-nvim
				trouble-nvim
				telescope-file-browser-nvim
				telescope-project-nvim
				mini-nvim
				markdown-preview-nvim
				nvim-cmp
				vim-godot
				cmp-nvim-lsp
				lsp-zero-nvim
		];
		extraConfig = lib.fileContents ./vim_configuration;
		extraPackages = with pkgs; [
			nodePackages.yaml-language-server
				nodePackages.vscode-langservers-extracted
				nodePackages.markdownlint-cli
				gitlint
				actionlint
		];
	};
}
