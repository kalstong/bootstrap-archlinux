let g:plug_threads=2
call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'eugen0329/vim-esearch'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf.vim'
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
" Plug 'nvim-treesitter/nvim-treesitter'
Plug 'pechorin/any-jump.vim'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'sainnhe/everforest'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/defx.nvim'
Plug 't9md/vim-choosewin'
Plug 'terryma/vim-smooth-scroll'

	" Other plugins to keep an eye on.
	" https://github.com/lewis6991/spellsitter.nvim
	" https://github.com/nvim-telescope/telescope.nvim
	" https://github.com/lifepillar/vim-mucomplete

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

" https://github.com/kristijanhusak/defx-git
" https://github.com/kristijanhusak/defx-icons
" --------------------------------------------
try
	call defx#custom#column('git', 'column_length', 2)
	call defx#custom#column('git', 'indicators', {
	\ 'Modified'  : '✹',
	\ 'Staged'    : '✚',
	\ 'Untracked' : '✭',
	\ 'Renamed'   : '➜',
	\ 'Unmerged'  : '═',
	\ 'Ignored'   : '☒',
	\ 'Deleted'   : '✖',
	\ 'Unknown'   : '?'
	\ })
catch
endtry

let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 2
let g:defx_icons_directory_icon = '🗀  '
let g:defx_icons_copy_icon = ''
let g:defx_icons_link_icon = ''
let g:defx_icons_move_icon = ''
let g:defx_icons_parent_icon = '🗁  '
let g:defx_icons_default_icon = ''
let g:defx_icons_directory_symlink_icon = '☊  '
let g:defx_icons_root_opened_tree_icon = '🗁  '
let g:defx_icons_nested_opened_tree_icon = '🗁  '
let g:defx_icons_nested_closed_tree_icon = '🗀  '

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
" 	show_end_of_line = false,
" }
" EOF

" https://github.com/ms-jpq/coq_nvim
" ----------------------------------
let g:coq_settings = {
	\ 'auto_start': 'shut-up',
	\ 'clients.snippets.warn': [],
	\ 'clients.third_party.enabled': v:false,
	\ }

" https://github.com/nvim-treesitter/nvim-treesitter
" --------------------------------------------------
" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"
" 	ensure_installed = {
" 		"bash", "c", "dockerfile", "fish", "go", "html",
" 		"javascript", "python", "vim", "yaml"
" 	},
" 	sync_install = false,
" 	ignore_install = {},
"
" 	highlight = {
" 		enable = true,
" 		disable = {},
" 	},
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

" https://github.com/Shougo/defx.nvim
" -----------------------------------
autocmd BufEnter * if &ft ==# 'defx' | call defx#redraw() | endif
autocmd BufWritePost * call defx#redraw()

try
	call defx#custom#column('mark', {
		\ 'readonly_icon': '✗ ',
		\ 'selected_icon': '✓ ',
		\ })
catch
endtry

function! _Defx_Root(path) abort
	return fnamemodify(a:path, ':t')
endfunction

try
	call defx#custom#source('file', { 'root': '_Defx_Root' })
catch
endtry

function! _Defx_IsOpenInCurrentTab()
	let l:winarray = map(range(1, winnr('$')), '[v:val, bufname(winbufnr(v:val))]')
	for wnd in l:winarray
		if stridx(wnd[1],'defx-' . tabpagenr()) >= 0
			return v:true
		endif
	endfor
	return v:false
endfunction

function! _Defx_JumpToFile(...)
	let fname = expand('%:p')
	if a:0 > 0
		let fname = getcwd() . '/' . a:1
	endif
	if _Defx_IsOpenInCurrentTab()
		exec "Defx -buffer-name=`'defx-'.tabpagenr()` " .
			\ "-columns=indent:mark:git:icons:filename:type " .
			\ "-search-recursive=" . fname . " `getcwd()`"
	else
		exec "Defx -buffer-name=`'defx-'.tabpagenr()` " .
			\ "-columns=indent:mark:git:icons:filename:type " .
			\ "-split=vertical -winwidth=30 -direction=topleft " .
			\ "-root-marker='' -ignored-files=.*,node_modules ".
			\ "-search-recursive=" . fname . " `getcwd()`"
	endif
endfunction

function! _Defx_Toggle()
	Defx -buffer-name=`'defx-'.tabpagenr()` -toggle
		\ -columns=indent:mark:git:icons:filename:type
		\ -split=vertical -winwidth=30 -direction=topleft
		\ -root-marker='' -ignored-files=.*,node_modules
		\ -columns=indent:mark:git:icons:filename:type
endfunction
