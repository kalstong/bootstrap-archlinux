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

" https://github.com/Shougo/defx.nvim
" -----------------------------------
function! _Defx_Settings() abort
nnoremap <silent><buffer><expr> <CR> defx#do_action('drop')
nnoremap <silent><buffer><expr> c defx#do_action('copy')
nnoremap <silent><buffer><expr> m defx#do_action('move')
nnoremap <silent><buffer><expr> p defx#do_action('paste')
nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> l defx#is_directory() ? defx#do_action('open') : defx#do_action('drop')
nnoremap <silent><buffer><expr> v defx#do_action('multi', [['drop', 'vsplit']])
nnoremap <silent><buffer><expr> i defx#do_action('multi', [['drop', 'split']])
nnoremap <silent><buffer><expr> tt defx#do_action('multi', [['drop', 'tabedit']])
nnoremap <silent><buffer><expr> o defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')
nnoremap <silent><buffer><expr> n defx#do_action('new_file')
nnoremap <silent><buffer><expr> N defx#do_action('new_multiple_files')
nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
nnoremap <silent><buffer><expr> d defx#do_action('remove')
nnoremap <silent><buffer><expr> r defx#do_action('rename')
nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
nnoremap <silent><buffer><expr> q defx#do_action('quit')
nnoremap <silent><buffer><expr> s defx#do_action('toggle_select') . 'j'
nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
nnoremap <silent><buffer><expr> C defx#do_action('change_vim_cwd')
nnoremap <silent><buffer><expr> <2-LeftMouse> defx#do_action('drop')
nnoremap <silent><buffer><expr> > defx#do_action('resize', defx#get_context().winwidth + 2)
nnoremap <silent><buffer><expr> < defx#do_action('resize', defx#get_context().winwidth - 2)
nnoremap <silent><buffer><expr> P defx#do_action('search', fnamemodify(defx#get_candidate().action__path, ':h'))
endfunction

nnoremap <Leader>we :call _Defx_JumpToFile()<CR>
nnoremap <Leader>wn :call _Defx_Toggle()<CR>
nnoremap <Leader>wp :call fzf#run(fzf#wrap({'sink': function('g:_Defx_JumpToFile')}))<CR>


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
