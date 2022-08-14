	" Indentation
	" -----------
	" Check [1] and [2] to understand these settings.
	" 1: https://tedlogan.com/techblog3.html
	" 2: http://vimcasts.org/episodes/tabs-and-spaces
set cindent
set cinoptions=:0,=1s,b1,g0,N0,(0,u0,U0)
set copyindent
set noexpandtab
set shiftwidth=4
set shortmess+=c
set smarttab
set softtabstop=0
set tabstop=4

runtime ./init.plug.vim
runtime ./init.chords.vim

	" Visual
	" ------
set completeopt+=menuone,noselect,noinsert
set guicursor=a:block-blink0,i:ver25-blinkwait150-blinkoff150-blinkon150
set ignorecase
set listchars=eol:¬,tab:\|\ ,space:·
set mouse=a
set nolist
set noshowmode
set wrap
set number
set omnifunc=syntaxcomplete#Complete
set relativenumber
set ruler
set scrolloff=8
set showbreak=↳\ 
set sidescroll=1
set smartcase
set splitbelow
set splitright
set switchbuf=usetab
set title

	" Colors
	" ------
syntax on
if $TERM != "linux"
	set termguicolors
endif
set background=dark
try
	let g:everforest_background = 'hard'
	let g:everforest_transparent_background = 1
	colorscheme everforest
catch
endtry

	" Functions
	" ---------
function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

	" Highlights
	" ----------
if exists("g:terminal_color_1")
	exe 'hi TrailingWhitespaces ctermbg=red guibg='.g:terminal_color_1
endif
hi CursorLine guibg=#323c41
hi FloatBorder guibg=NONE


	" Other
	" -----
autocmd BufLeave,BufWinLeave,FocusLost,VimLeave,WinLeave * setlocal nocursorline
autocmd BufEnter,BufWinEnter,FocusGained,VimEnter,WinEnter * setlocal cursorline
autocmd BufEnter,BufNewFile,BufRead * setlocal formatoptions=jql
autocmd BufEnter * let &titlestring=expand('%:t')
autocmd BufWinLeave * call clearmatches()
autocmd FileType fzf set nonumber norelativenumber

match TrailingWhitespaces /\s\+$/
autocmd BufWinEnter * match TrailingWhitespaces /\s\+$/
autocmd InsertEnter * match TrailingWhitespaces /\s\+\%#\@<!$/
autocmd InsertLeave * match TrailingWhitespaces /\s\+$/

" Jump to the last known position when re-opening a file
if has("autocmd")
	au BufWinEnter *
		\	if line("'\"") > 0 && line("'\"") <= line("$") |
		\		exe "normal! g`\" zz" |
		\	endif
endif

" Automatically reload a file if it has changed on disk.
" Taken from https://unix.stackexchange.com/a/383044
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed. Buffer was reloaded." | echohl None
