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

if exists("&mle")
	set mle
endif

" Set cindent opintions. See :help cinoptions-values
au FileType c,cpp set cino=:0,g0,(0,W2s,l1,N-s,E-s

" color
colo oct22

" window manipulation
no <C-w><C-h> <C-w>h
no <C-w><C-j> <C-w>j
no <C-w><C-k> <C-w>k
no <C-w><C-l> <C-w>l
no <C-w><C-v> <C-w>v
no <C-w><C-s> <C-w>s
no <C-w><C-q> <C-w>q
no <C-w><C--> <C-w>-
no <C-w><C-=> <C-w>+
no <C-w><C-,> <C-w><
no <C-w><C-.> <C-w>>

" Move cursor in insert mode
ino <C-h> <C-o>h
ino <C-j> <C-o>j
ino <C-k> <C-o>k
ino <C-l> <C-o>a
ino <C-f> <C-o>f
ino <C-S-f> <C-o>F
" As we cannot map <C-<num>>, we use Emacs-like motion
ino <M-m> <C-o>^
ino <C-a> <C-o>0
ino <C-e> <C-o>$

" Run script
no -r	:w\|!./%<cr>

" Reselect visual block after
vnoremap < <gv
vnoremap > >gv

" Prompt on :tabe or :e
set wildmenu
set wim=longest:full

" Quick move in long line
nn <expr> j v:count ? 'j' : 'gj'
nn <expr> k v:count ? 'k' : 'gk'

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
			\ set ts=4 sw=4 sts=4 et

au FileType c,cpp
			\ set et

set cursorline
set relativenumber

let g:python3_host_prog = "/usr/bin/python3"

" no jump after pressing *
nn * m`:keepjumps norm! *``<cr>


" html auto close
au FileType html,xml
			\ setl omnifunc=htmlcomplete#CompleteTags
			\|inoremap </ </<c-x><c-o><esc>==a

" scheme indent for `if`
au FileType scheme
			\ setl lispwords-=if
			\|setl ts=4 sw=4 sts=4 et
"			\|imap ( ()<left>

" python indent
au FileType python
			\ setl ts=2 sw=2 sts=2 et cuc

" for nvim
if has('nvim')
	set rtp^=/usr/share/vim/vimfiles
	set guicursor=
end

" extra local config
let s:extra_conf = expand('<sfile>:p:h') . '/extra_conf.vim'
if filereadable(s:extra_conf)
	exe 'source ' . s:extra_conf
end

"----- For Plugins ----
"-- lightline --
set laststatus=2
let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'component_function': {
	\	'filename': 'LightlineFilename',
	\ }
	\ }

function! LightlineFilename()
	let root = fnamemodify(get(b:, 'git_dir'), ':h')
	let path = expand('%:p')
	if path[:len(root)-1] ==# root
		return path[len(root)+1:]
	endif
	return path
endfunction

"-- emmet --
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

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

"-- riv --
let g:riv_auto_format_table = 0

"-- vim-lsp-cxx-highlight
let g:lsp_cxx_hl_use_text_props = 1
hi default LspCxxHlGroupEnumConstant ctermfg=176
hi default LspCxxHlGroupNamespace ctermfg=136
hi default LspCxxHlGroupMemberVariable ctermfg=81

"-- LanguageClient --
let s:ccls_settings = {
	\ 'highlight': { 'lsRanges' : v:true  },
	\ }

let s:ccls_command = ['ccls',
	\ '--init=' . json_encode(s:ccls_settings), '--log-file=/tmp/ccls.sr.log']

let g:LanguageClient_serverCommands = {
    \ 'cpp': s:ccls_command,
    \ 'c': s:ccls_command,
	\ 'python': ['pyls', '--log-file=/tmp/pyls.log'],
    \ }

" disable diagnosis while typing and do it only when leaving Insert Mode
"au VimEnter * if exists('*LanguageClient#handleTextChanged')
"		\|aug languageClient
"		\|	exe "au! TextChangedP"
"		\|	exe "au! TextChangedI"
"		\|	exe "au InsertLeave * call LanguageClient#handleTextChanged()"
"		\|aug END
"	\|endif

let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = expand('~/.vim/ccls_settings.json')
let g:LanguageClient_changeThrottle = v:null
"let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
"let g:LanguageClient_loggingLevel = 'DEBUG'
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()

nn <silent> gh :call LanguageClient_textDocument_hover()<CR>
nn <silent> gd :call LanguageClient_textDocument_definition()<CR>
nn <silent> gr :call LanguageClient_textDocument_references()<CR>
nn <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nn <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

au FileType c,cpp
	\ nn <silent> <C-j> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'D'})<cr>
	\|nn <silent> <C-k> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'U'})<cr>
	\|nn <silent> <C-h> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'L'})<cr>
	\|nn <silent> <C-l> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'R'})<cr>
	\|nn <silent> gxb :call LanguageClient#findLocations({'method':'$ccls/inheritance'})<cr>
	\|nn <silent> gxB :call LanguageClient#findLocations({'method':'$ccls/inheritance','levels':3})<cr>
	\|nn <silent> gxd :call LanguageClient#findLocations({'method':'$ccls/inheritance','derived':v:true})<cr>
	\|nn <silent> gxD :call LanguageClient#findLocations({'method':'$ccls/inheritance','derived':v:true,'levels':3})<cr>
	\|nn <silent> gxc :call LanguageClient#findLocations({'method':'$ccls/call'})<cr>
	\|nn <silent> gxC :call LanguageClient#findLocations({'method':'$ccls/call','callee':v:true})<cr>
	\|nn <silent> gxs :call LanguageClient#findLocations({'method':'$ccls/member','kind':2})<cr>
	\|nn <silent> gxf :call LanguageClient#findLocations({'method':'$ccls/member','kind':3})<cr>
	\|nn <silent> gxm :call LanguageClient#findLocations({'method':'$ccls/member'})<cr>
	\|let b:lc_pword = ""
	\|au CursorMoved <buffer=abuf>
		\ let b:lc_cword = expand("<cword>")
		\|if b:lc_cword != b:lc_pword
		\|	sil call LanguageClient#textDocument_documentHighlight()
		\|  let b:lc_pword = b:lc_cword
		\|endif

"-- deoplete
let g:deoplete#enable_at_startup = 1
au VimEnter *
	\ call deoplete#custom#source('LanguageClient', {
		\ 'max_abbr_width': 0,
		\ 'max_menu_width': 0 })
"au VimEnter * call deoplete#custom#option('sources', {
"	\ 'cpp': ['LanguageClient'],
"	\})

"-- misc
set cscopequickfix=s-,c-,d-,i-,t-,e-
set completeopt=longest,menu

"-- vim-grammarous
"let g:grammarous#languagetool_cmd = 'languagetool'
hi SpellBad None
hi link SpellBad ErrorMsg

"-- vimtex
let g:vimtex_complete_enabled = 1
let g:vimtex_compiler_latexmk = {
	\ 'backend': 'jobs',
	\ 'callback': 1,
	\ 'continuous': 1,
	\ 'options': ['-synctex=1', '-interaction=nonstopmode']
	\}

"-- echodoc
set noshowmode "avoid '--INSERT--' overriding it
let g:echodoc#enable_at_startup = 1

"-- NERDTree
"autocmd vimenter * NERDTree | wincmd w
no <silent> <F8> :NERDTreeToggle<cr>
let g:NERDTreeShowHidden=1
let g:NERDTreeMapPreview = 'p'
let g:NERDTreeMapJumpParent = 'P'
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowLineNumbers = 1

"-- rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
	\ 'ctermfgs': ['darkblue', 'darkyellow', 'darkcyan', 'darkmagenta'],
	\ }

"-- diffchar.vim
let g:DiffUnit = 'Word3'

" --
" hightlight RedundantSpace
au BufEnter *
	\ hi RedundantSpace ctermbg=red ctermfg=red
	\|match RedundantSpace /\s\+$/

" vim:set noet ts=4 sts=4 sw=4:
