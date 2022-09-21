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
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
Plug 'neovim/nvim-lspconfig'
Plug 'ntpeters/vim-better-whitespace'
Plug 'onsails/lspkind.nvim'
Plug 'pechorin/any-jump.vim'
Plug 'preservim/nerdcommenter'
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
			{
				name = 'buffer',
				-- See more options at https://github.com/hrsh7th/cmp-buffer#configuration
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end
			}},
			{ name = 'nvim_lsp' },
			{ name = 'nvim_lsp_signature_help' },
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
	local servers = {}
	for _, lsp in ipairs(servers) do
		lspconfig[lsp].setup{ capabilities = capabilities }
	end
EOF
catch
endtry

" https://github.com/itchyny/lightline.vim
" ----------------------------------------
function! RenderFileType()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction
function! RenderFileFormat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction
function! RenderTabName(name)
	let l:filename = lightline#tab#filename(a:name)
	return l:filename
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


" https://github.com/neovim/nvim-lspconfig
" ----------------------------------------
try
lua <<EOF
local lspconfig = require('lspconfig')
EOF
catch
endtry

" https://github.com/ntpeters/vim-better-whitespace
" -------------------------------------------------
let g:better_whitespace_enabled=1

" https://github.com/pechorin/any-jump.vim
" ----------------------------------------
let g:any_jump_disable_default_keybindings = 1

" https://github.com/preservim/nerdcommenter
" ------------------------------------------
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1
