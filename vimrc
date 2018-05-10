" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim funcalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim74/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

"----------------this is the old vimrc file-----------------------
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set number
set wrapscan
filetype plugin on

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		" Also don't do it when the mark is in the first line, that is the default
		" position when opening a file.
		autocmd BufReadPost *
					\ if line("'\"") > 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif

	augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

" Set cindent opintions. See :help cinoptions-values
au FileType c set cino=:0,g0,(0

" color
colo oct22

" window opearte
nno <space> w
no wd <C-w>h
no wh <C-w>j
no wt <C-w>k
no wn <C-w>l
no wD <C-w>H
no wH <C-w>J
no wT <C-w>K
no wN <C-w>L
no wv <C-w>v
no ws <C-w>s
no wq <C-w>q
no w- <C-w>-
no w= <C-w>+
no w, <C-w><
no w. <C-w>>

" Run script
no -r	:w\|!./%<cr>

" Dvorak hack
no d h
no h j
no t k
no n l
no S :
no j d
no l n
no L N
no k t

" Reselect visual block after
vnoremap < <gv
vnoremap > >gv

" Misc
au QuickFixCmdPost [^l]* nested cwindow
au QuickFixCmdPost    l* nested lwindow

au BufRead /tmp/mutt-* set tw=72
au FileType tex set tw=80
set noeb vb t_vb=
set ttimeoutlen=100
set tags=./tags,../tags,../../tags
set fileencodings=ucs-bom,utf-8,cp936,gb3212,gbk,gb18030,big5 ",latin1

set fo+=mj

set ts=4 sw=4
set so=3

set previewheight=5

au FileType java
			\ set ts=4 sw=4 et softtabstop=4

set cursorline

" hightlight RedundantSpace
hi RedundantSpace ctermbg=red ctermfg=red
match RedundantSpace /\s\+$/

" html auto close
au FileType html,xml
			\ set omnifunc=htmlcomplete#CompleteTags
			\|inoremap </ </<c-x><c-o><esc>==a

" scheme indent for `if`
au FileType scheme
			\ set lispwords-=if
			\|set ts=4 sw=4 sts=4 et
"			\|imap ( ()<left>

" python indent
au FileType python
			\ set ts=2 sw=2 sts=2 et

" for nvim
if has('nvim')
	set rtp^=/usr/share/vim/vimfiles
end

"----- For Plugins ----
"-- vimshell --
"augroup vimshell_keymap_fix
"	au!
"	au FileType vimshell,int-* call Fix_vimshell_keymaps()
"augroup END
"func! Fix_vimshell_keymaps()
"	nun <buffer> dd
"	iu <buffer> <C-l>
"	im <buffer> <C-l> <Plug>(vimshell_clear)
"	if &ft == 'int-scheme'
"		iu <buffer> <Tab>
"	endif
"endf
"nmap sc :VimShellSendString<cr>

"-- netrw --
augroup netrw_dvorak_fix
	au!
	au FileType netrw call Fix_netrw_keymaps()
augroup END

func! Fix_netrw_keymaps()
	" dirty hack for mapping <c-t> to origin t
	" to open file in new tab
	if !exists("g:my_netrw_t_map")
		let g:my_netrw_t_map = maparg('t', 'n')
	endif
	exe "nnoremap <buffer> <c-t> ".g:my_netrw_t_map

	nnoremap <buffer> d h
	nnoremap <buffer> h gj
	nnoremap <buffer> t gk
	nnoremap <buffer> n l
	nnoremap <buffer> e d
	nnoremap <buffer> l n
endf

func! s:Toggle_netrw()
	let curwin = winnr()
	if exists("t:my_netrw_bufnr")
		let exwin = bufwinnr(t:my_netrw_bufnr)
		exe exwin."wincmd w"
		close
		if exwin < curwin
			let curwin -= 1
		endif
		unlet t:my_netrw_bufnr
		exe curwin."wincmd w"
	else
		exe "Sexplore"
		if curwin >= winnr()
			let curwin += 1
		endif
		let g:netrw_chgwin = curwin
		let t:my_netrw_bufnr = bufnr('%')
	endif
endf
no <silent> <F8> :call <SID>Toggle_netrw()<cr>

"-- lightline --
set laststatus=2
let g:lightline = {}
let g:lightline.colorscheme = 'wombat'

"-- emmet --
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"-- YCM --
"if has('nvim')
"	let g:loaded_youcompleteme = 0
"endif
"au FileType cpp,c
"			\ let g:ycm_global_ycm_extra_conf="~/.vim/ycm_extra_conf.py"
"let g:ycm_goto_buffer_command = 'new-or-existing-tab'
"let g:ycm_complete_in_comments = 1
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_seed_identifiers_with_syntax = 1
"let g:ycm_collect_identifiers_from_tags_files = 1
""let g:ycm_server_keep_logfiles = 1
"let g:ycm_always_populate_location_list = 1
"let g:ycm_server_log_level = 'debug'
"let g:ycm_min_num_of_chars_for_completion = 1
"let g:ycm_key_invoke_completion = '<S-Enter>'
"let g:ycm_semantic_triggers =  {
"			\ 'c' : ['->', '.'],
"			\ 'objc' : ['->', '.'],
"			\ 'ocaml' : ['.', '#'],
"			\ 'cpp,objcpp' : ['->', '.', '::'],
"			\ 'perl' : ['->'],
"			\ 'php' : ['->', '::'],
"			\ 'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
"			\ 'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
"			\ 'ruby' : ['.', '::'],
"			\ 'lua' : ['.', ':'],
"			\ 'erlang' : [':'],
"			\ 'vhdl' : ['a', '.']
"			\ }
"let g:ycm_filetype_blacklist = {
"			\ 'html': 1,
"			\ 'text': 1,
"			\ 'mail': 1,
"			\ }

"-- A --
nnoremap -a :A<cr>

"-- Taglist --
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Auto_Open = 1
let Tlist_Display_prototype = 1

"-- AutoPairs
au FileType scheme let b:AutoPairs = {"(": ")", "{": "}", "[": "]"}
let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose = 0
let g:AutoPairsSmartMode = 1
let g:AutoPairsMapCh = 0

"-- ydcv --
func! SearchWord()
	echo system('ydcv --', expand("<cword>"))
endf
no mm :call SearchWord()<cr>

"-- ag --
"command Agg exe 'Ag -Q ' . expand('<cword>')

"-- riv --
let g:riv_auto_format_table = 0

"-- LanguageClient --
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['ccls', '--log-file=/tmp/cq.log'],
    \ 'c': ['ccls', '--log-file=/tmp/cq.log'],
    \ }

let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = expand('~/.vim/ccls_settings.json')
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()

nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

"-- deoplete
let g:deoplete#enable_at_startup = 1

"-- misc
set cscopequickfix=s-,c-,d-,i-,t-,e-
set completeopt=longest,menu

"-- codi
let g:codi#log = '/tmp/codilog'
