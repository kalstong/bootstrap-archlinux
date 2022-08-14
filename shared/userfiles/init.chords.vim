" SEARCH
" ------
" <SPACE>ff: Search and replace across all files in the working directory.
" <SPACE>sa: Search content of all files in the working directory.
" <SPACE>sb: Search the current buffer.
" <SPACE>sd: Search for folders in the working directory.
" <SPACE>sf: Search the content of all opened files.
" <SPACE>sh: Search file history.
" <SPACE>sw: Search word under cursor in all files in the working directory.
" <SPACE>wf: Search windows.
"
" SELECTION
" ---------
" <SPACE>ws: Select window

" Auxiliary Functions
" -------------------
function! WinBufSwap()
	let thiswin = winnr()
	let thisbuf = bufnr("%")
	let lastwin = winnr("#")
	let lastbuf = winbufnr(lastwin)

	exec lastwin . " wincmd w" ."|".
		\ "buffer ". thisbuf ."|".
		\ thiswin ." wincmd w" ."|".
		\ "buffer ". lastbuf
endfunction

augroup netwr_key_mappings
	autocmd!
	autocmd filetype netrw call s:MapNetrwKeys()
augroup END
function! s:MapNetrwKeys()
	noremap _ :b#<CR>
endfunction

" VIM-only
" --------
tnoremap <ESC> <C-\><C-n>
let mapleader="\<SPACE>"

	" Windows
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wx :call WinBufSwap()<CR>
nnoremap <Leader>w<S-h> <C-w><S-h>
nnoremap <Leader>w<S-j> <C-w><S-j>
nnoremap <Leader>w<S-k> <C-w><S-k>
nnoremap <Leader>w<S-l> <C-w><S-l>
nnoremap <Leader>wz1 <C-w>_ <bar> <C-w>\|
nnoremap <Leader>wz0 <C-w>=

	" Tabs
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>
nnoremap tj :tabprev<CR>
nnoremap tk :tabnext<CR>
nnoremap te :tabedit<Space>
nnoremap tn :tabnew<CR>
nnoremap tm :tabmove<Space>
nnoremap td :tabclose<CR>

	" Search and Replace
nnoremap <Leader>sc :noh<CR>:set nospell<CR>
nnoremap <Leader>ss :set spell<CR>
nnoremap * :keepjumps normal! msHmt`s*`tzt`s<CR>
nnoremap # :keepjumps normal! msHmt`s#`tzt`s<CR>
nnoremap <Leader>re :%s///gc<left><left><left><left>
nnoremap <Leader>rw :%s/<C-r><C-w>//gc<left><left><left>

	" Toggle visual elements
nnoremap <Leader>vn0 :set nonumber<CR>
nnoremap <Leader>vn1 :set number<CR>
nnoremap <Leader>vl0 :set nolist<CR>
nnoremap <Leader>vl1 :set list<CR>
nnoremap <Leader>vc0 :set colorcolumn=0<CR>
nnoremap <Leader>vc1 :set colorcolumn=80<CR>
nnoremap <Leader>vc2 :set colorcolumn=100<CR>
nnoremap <Leader>vc3 :set colorcolumn=120<CR>
nnoremap <Leader>vs0 :syntax off<CR>
nnoremap <Leader>vs1 :syntax on<CR>

	" Navigation
nnoremap _ :bp<CR>
nnoremap <A-n> <A-}>
nnoremap <A-b> <A-{>
vnoremap <A-n> <A-}>
vnoremap <A-b> <A-{>
inoremap <C-q> <ESC>:x<CR>
nnoremap <C-q> :x<CR>
inoremap <C-s> <ESC>:up!<CR>i<Right>
nnoremap <C-s> <ESC>:up!<CR>
inoremap <C-a> <ESC>:wa!<CR>i<Right>
nnoremap <C-a> <ESC>:wa!<CR>
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" https://github.com/junegunn/fzf.vim
" -----------------------------------
function! AgFzf(query, fullscreen)
	let query = empty(a:query) ? '^(?=.)' : a:query
	let ag_extra_opts = '--hidden --no-mmap --smart-case --workers 2'
	let fzf_opts = { 'options': [ '--delimiter', ':', '--nth', '2..' ] }
	call fzf#vim#ag(query, ag_extra_opts, fzf#vim#with_preview(fzf_opts), a:fullscreen)
endfunction
command! -nargs=* -bang AG call AgFzf(<q-args>, <bang>0)

function! FilterHistory(expr)
	call filter(v:oldfiles, 'v:val !~ "COMMIT_EDITMSG"')
	call filter(v:oldfiles, 'v:val =~ ' . '"' . a:expr . '"')
endfunction

function! RgFzf(query, fullscreen)
	let rg_cmd = 'rg --no-mmap --threads 2 --column --line-number --no-heading --hidden --color=always --smart-case  --glob !\.git/ -- ' . shellescape(a:query)
	let fzf_opts = { 'options': [ '--delimiter', ':', '--nth', '2..' ] }
	call fzf#vim#grep(rg_cmd, 1, fzf#vim#with_preview(fzf_opts), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RgFzf(<q-args>, <bang>0)

" https://github.com/kyazdani42/nvim-tree.lua
" -------------------------------------------
nnoremap <Leader>we :NvimTreeFindFile<CR>
nnoremap <Leader>wn :NvimTreeToggle<CR>

nnoremap , :Buffers<CR>
nnoremap ; :Files<CR>
nnoremap - :call FilterHistory(getcwd())<CR>:History<CR>
nnoremap m :GFiles?<CR>
nnoremap <Leader>sa :RG<CR>
nnoremap <Leader>sb :BLines<CR>
nnoremap <Leader>sd :call fzf#run(fzf#wrap({'source': 'fd --type d'}))<CR>
nnoremap <Leader>sf :Lines<CR>
nnoremap <Leader>sh :call FilterHistory(getcwd())<CR>:History<CR>
nnoremap <Leader>sta :Tags <C-r><C-w><CR>
nnoremap <Leader>stb :BTags <C-r><C-w><CR>
nnoremap <Leader>sw :RG <C-r><C-w><CR>

" https://github.com/pechorin/any-jump.vim
" ----------------------------------------
nnoremap <Leader>sj :AnyJump<CR>

" https://github.com/t9md/vim-choosewin
" -------------------------------------
nmap <Leader>ws <Plug>(choosewin)
nmap <Leader>wf :Windows<CR>

" https://github.com/terryma/vim-smooth-scroll
" --------------------------------------------
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 9, 2)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 9, 2)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 9, 4)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 9, 4)<CR>
