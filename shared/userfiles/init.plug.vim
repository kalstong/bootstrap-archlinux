let g:plug_threads=2
call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'eugen0329/vim-esearch'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
Plug 'machakann/vim-sandwich'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind.nvim'
Plug 'pechorin/any-jump.vim'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'sainnhe/everforest'
Plug 'sheerun/vim-polyglot'
Plug 't9md/vim-choosewin'
Plug 'terryma/vim-smooth-scroll'

	" Other plugins to keep an eye on.
	" https://github.com/lewis6991/spellsitter.nvim
	" https://github.com/nvim-telescope/telescope.nvim
	" https://github.com/lifepillar/vim-mucomplete
	" Plug 'ludovicchabant/vim-gutentags'
	" Plug 'lukas-reineke/indent-blankline.nvim'
	" Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

" https://github.com/eugen0329/vim-esearch
" ----------------------------------------
let g:esearch = {
	\ 'adapter': 'rg',
	\ 'backend': 'nvim',
	\ 'batch_size': 2048,
	\ 'default_mappings': 1,
	\ 'live_update': 1,
	\ 'out': 'win',
	\ 'use': ['visual', 'last'],
	\ }

" https://github.com/hrsh7th/nvim-cmp
" -----------------------------------
set completeopt=menu,menuone,noselect
try
lua << EOF
	local cmp = require('cmp')
	local lspkind = require('lspkind')

	cmp.setup({
		snippet = {
			expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-c>'] = cmp.mapping.abort(),
			['<Tab>'] = cmp.mapping.select_next_item(),
			['<S-Tab>'] = cmp.mapping.select_prev_item(),
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = 'buffer' },
			{ name = 'nvim_lsp' },
			{ name = 'nvim_lsp_signature_help' }
		}),
		formatting = {
			-- Setup lspkind.
			format = lspkind.cmp_format({
				maxwidth = 50,
				mode = 'symbol_text',
			})
		},
	})

	-- Setup lspconfig.
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	local lspconfig = require('lspconfig')
	local servers = { 'bashls', 'tsserver', 'vimls' }
	for _, lsp in ipairs(servers) do
		lspconfig[lsp].setup{ capabilities = capabilities }
	end
EOF
catch
endtry

" https://github.com/itchyny/lightline.vim
" ----------------------------------------
function! RenderFileType()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! RenderFileFormat()
	return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
function! RenderTabName(name)
	let l:filename = lightline#tab#filename(a:name)
	return (WebDevIconsGetFileTypeSymbol(l:filename) . ' ' . l:filename)
endfunction

let g:lightline = {
	\ 'enable': {
	\   'statusline': 1,
	\   'tabline': 1,
	\ },
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\   'left': [[ 'mode', 'paste' ],
	\            [ 'gitbranch', 'readonly', 'relativepath', 'modified' ]]
	\ },
	\ 'inactive': {
	\   'left': [[ 'readonly', 'relativepath', 'modified' ]]
	\ },
	\ 'tabline': {
	\   'left': [[ 'tabs' ]],
	\   'right': [[ 'close' ]]
	\ },
	\ 'tab' : {
	\   'active': [ 'rendertab' ],
	\   'inactive': [ 'rendertab' ],
	\ },
	\ 'tab_component_function' : {
	\   'rendertab': 'RenderTabName',
	\ },
	\ 'component_function': {
	\   'gitbranch': 'gitbranch#name',
	\   'filetype': 'RenderFileType',
	\   'fileformat': 'RenderFileFormat',
	\ },
\ }

" https://github.com/kyazdani42/nvim-tree.lua
" -------------------------------------------
try
lua <<EOF
require("nvim-tree").setup {
	auto_reload_on_write = true,
	create_in_closed_folder = false,
	disable_netrw = false,
	hijack_cursor = false,
	hijack_netrw = true,
	hijack_unnamed_buffer_when_opening = false,
	ignore_buffer_on_setup = false,
	open_on_setup = false,
	open_on_setup_file = false,
	open_on_tab = false,
	ignore_buf_on_tab_change = {},
	sort_by = "name",
	root_dirs = {},
	prefer_startup_root = false,
	sync_root_with_cwd = false,
	reload_on_bufenter = false,
	respect_buf_cwd = false,
	on_attach = "disable",
	remove_keymaps = false,
	view = {
		adaptive_size = true,
		centralize_selection = false,
		width = 30,
		height = 30,
		hide_root_folder = true,
		side = "left",
		preserve_window_proportions = false,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
		float = {
			enable = true,
			open_win_config = {
				relative = "win",
				border = "rounded",
				style = "minimal",
			},
		},
	},
	renderer = {
		add_trailing = false,
		group_empty = false,
		highlight_git = false,
		full_name = false,
		highlight_opened_files = "none",
		root_folder_modifier = ":~",
		indent_markers = {
			enable = false,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				bookmark = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "✹",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "✖",
					ignored = "◌",
				},
			},
		},
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		symlink_destination = true,
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	update_focused_file = {
		enable = false,
		update_root = false,
		ignore_list = {},
	},
	ignore_ft_on_setup = {},
	system_open = {
		cmd = "",
		args = {},
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		debounce_delay = 50,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	filters = {
		dotfiles = true,
		custom = {},
		exclude = {},
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
	},
	git = {
		enable = true,
		ignore = true,
		show_on_dirs = true,
		timeout = 400,
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
		remove_file = {
			close_window = true,
		},
	},
	trash = {
		cmd = "gio trash",
		require_confirm = true,
	},
	live_filter = {
		prefix = "[FILTER]: ",
		always_show_folders = true,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			dev = false,
			diagnostics = false,
			git = false,
			profile = false,
			watcher = false,
		},
	},
}
EOF
catch
endtry

" https://github.com/ludovicchabant/vim-gutentags
" -----------------------------------------------
" let g:gutentags_generate_on_missing = 0
" let g:gutentags_generate_on_new = 0
" let g:gutentags_generate_on_write = 0
" let g:gutentags_modules = [ 'ctags' ]
" let g:gutentags_project_root = [ '.root', '.git' ]

" https://github.com/lukas-reineke/indent-blankline.nvim
" ------------------------------------------------------
" lua <<EOF
" require("indent_blankline").setup {
"	show_end_of_line = false,
" }
" EOF

" https://github.com/neovim/nvim-lspconfig
" ----------------------------------------
try
lua <<EOF
local lspconfig = require('lspconfig')

lspconfig.bashls.setup {
	cmd_env = {
		SHELLCHECK_PATH = '',
		HIGHLIGHT_PARSING_ERRORS = true,
	},
}

-- See more at https://github.com/typescript-language-server/typescript-language-server#initializationoptions
lspconfig.tsserver.setup {
	init_options = {
		hostInfo = "neovim",
		disableAutomaticTypingAcquisition = true,
		prefences = {
			includeCompletionsForModuleExports = true,
			includeCompletionsForImportStatements = true,
			includeAutomaticOptionalChainCompletions = true,
		},
	},
}

lspconfig.vimls.setup {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	init_options = {
		diagnostic = { enable = true },
		indexes = {
			count = 3,
			gap = 100,
			projectRootPatterns = {
				"runtime", "nvim", ".git",
				"autoload", "plugin"
			},
			runtimepath = true
		},
		isNeovim = true,
		iskeyword = "@,48-57,_,192-255,-#",
		runtimepath = "",
		suggest = {
			fromRuntimepath = true,
			fromVimruntime = true
		},
		vimruntime = ""
	}
}
EOF
catch
endtry

" https://github.com/nvim-treesitter/nvim-treesitter
" --------------------------------------------------
" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"
"	ensure_installed = {
"		"bash", "c", "dockerfile", "fish", "go", "html",
"		"javascript", "python", "vim", "yaml"
"	},
"	sync_install = false,
"	ignore_install = {},
"
"	highlight = {
"		enable = true,
"		disable = {},
"	},
" }
" EOF

" https://github.com/pechorin/any-jump.vim
" ----------------------------------------
let g:any_jump_disable_default_keybindings = 1

" https://github.com/preservim/nerdcommenter
" ------------------------------------------
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1
