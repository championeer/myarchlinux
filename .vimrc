" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"General Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set encoding for Chinese
set encoding=UTF-8
set helplang=cn
let &termencoding=&encoding
set fileencodings=utf-8,cp936,ucs-bom,gb18030,gbk,gb2312 

if version >= 603
set helplang=cn
endif

set nu " display line number

set cmdheight=1

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"set nobackup " do not keep a backup file, use versions instead
"else
"set backup " keep a backup file
"endif

set history=500 " keep 100 lines of command line history
set ruler " show the cursor position all the time
"set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\%p%%%)
set showcmd " display incomplete commands
set incsearch " do incremental searching
set confirm " popup confirm box when unsaving or opening readonly files
set clipboard+=unnamed " share clipboard with windows
set viminfo+=! " save globle var
set iskeyword+=_,$,@,%,#,- "no newline when meeting these characters
set paste      "set paste mode
"光标在窗口上下边界时距离边界7行即开始滚屏
set so=7

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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

"statusbar color
highlight StatusLine guifg=SlateBlue guibg=Yellow
highlight StatusLineNC guifg=Gray guibg=White

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "normal g`\"" |
\ endif

augroup END

else

set autoindent " always set autoindenting on

endif " has("autocmd") 



"Enable folding
"set nofen
"set fdl=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Indent
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Auto indent
set ai

"Smart indent
set si

"C-style indenting
set cindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"File setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""
set linespace=0
set wildmenu

set mouse=a

set report=0
set noerrorbells

"Set to auto read when a file is changed from the outside
set autoread

"edit another file in the same directory as the current file
"   uses expression to extract path from current file's path
"   "  (thanks Douglas Potts)
if has("unix")
   map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
   map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""           
"Search and match
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch
set matchtime=5
set ignorecase
set smartcase
set incsearch

"set listchars=tab:\|\,trail:.,extends:>,precedes:<,eol:$
set scrolloff=3
set novisualbell

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Text fromat and layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"auto format
set formatoptions=tcrqn
set tabstop=4
set softtabstop=4
set shiftwidth=4
"tab->space
set expandtab                   
"set nowrap
set smarttab        

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type="name"

" Set vim plugins settings
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=0
let Tlist_Compact_Format=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Inc_Winwidth=1
let Tlist_Enable_Fold_Column=0

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Set bracket matching and comment formats
"""""""""""""""""""""""""""""""""""""""""""""""""""
set matchpairs+=<:>
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=n::

"""""""""""""""""""""""""""""""""""
" Cursor keys suck. Use ctrl with home keys to move in insert mode.
"""""""""""""""""""""""""""""""""""
"imap <C-h> <Left>
"imap <C-j> <Down>
"imap <C-k> <Up>
"imap <C-l> <Right>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Press ,e to jump to the same dir as current file
""""""""""""""""""""""""""""""""""""""""""""""""""
if has("unix")
    map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
    map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"Turn on completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

set foldenable
"set foldmethod=manual
set foldmethod=marker
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" open urls with firefox
command -bar -nargs=1 OpenURL :!firefox <args>
 
""""""""""""""""""""""""""""""""""
" () [] {}
""""""""""""""""""""""""""""""""""
noremap! "" ""<left>
noremap! '' ''<left>
noremap! (( ()<left>
noremap! (<cr> (<cr>)<c-o>O
noremap! (; ();<esc>hi
noremap! (<cr>; (<cr>);<c-o>O
noremap! ('; ('');<esc>hhi
noremap! ("; ("");<esc>hhi
noremap! (' ('')<esc>hi
noremap! (" ("")<esc>hi
noremap! {{ {}<left>
noremap! {<cr> {<cr>}<c-o>O
noremap! {; {};<esc>hi
noremap! {<cr>; {<cr>};<c-o>O
noremap! {'; {''};<esc>hhi
noremap! {"; {""};<esc>hhi
noremap! {' {''}<esc>hi
noremap! {" {""}<esc>hi
noremap! [[ []<left>
noremap! [<cr> [<cr>]<c-o>O
noremap! [; [];<esc>hi
noremap! [<cr>; [<cr>];<c-o>O
noremap! ['; [''];<esc>hhi
noremap! ["; [""];<esc>hhi
noremap! [' ['']<esc>hi
noremap! [" [""]<esc>hi

"""""""""""""""""""""""""""""""""""""
" use XHTML and CSS with :TOhtml
"""""""""""""""""""""""""""""""""""""
"let use_xhtml=1
"let html_use_css=1
"let html_ignore_folding=1
"let html_use_encoding="UTF-8"

"""""""""""""""""""""""""""""""
" => Minibuffer
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1
let g:miniBufExplMaxSize = 0
let g:bufExplorerSortBy = "name"

map <Leader>c :CMiniBufExplorer<cr>
map <Leader>u :UMiniBufExplorer<cr>
map <Leader>t :TMiniBufExplorer<cr>
autocmd BufRead,BufNew :call UMiniBufExplorer
""""""""""""""""""""""""""""""""""""
" bufExplorer
""""""""""""""""""""""""""""""""""""
"map <leader>be :BufExplorer<cr>

""""""""""""""""""""""""""""""""""""
" buftabs
""""""""""""""""""""""""""""""""""""
noremap <C-tab> :bnext<CR>
noremap <C-S-tab> :bprev<CR>
let g:buftabs_only_basename=1
let g:buftabs_in_statusline=1
""""""""""""""""""""""""""""""""""""
" Set taglist plugin options
""""""""""""""""""""""""""""""""""""
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 0
let Tlist_Inc_Winwidth = 1

" Toggle taglist script
"map <F7> :Tlist<CR>
map <F6> :TlistToggle
map <F7> :TlistUpdate
"""""""""""""""""""""""""""""""""""
" Some key mapping
"""""""""""""""""""""""""""""""""""
" 取消被搜索字串的高亮 
nmap <F2> :nohls<cr> 
" 命令模式下转移光标到不同窗口 
nmap <F4> <C-W>w
map <F5> <Esc>gg=G''
map <F9> :DiffChangesDiffToggle
map <F10> :DiffChangesPatchToggle
map <A-Right> gt
map <A-Left> gT
" paste/nopaste
set pastetoggle=<F11>

""""""""""""""""""""""""""""""""""
" VTreeExplorer
""""""""""""""""""""""""""""""""""
map <F12> :VSTreeExplore <CR>
let g:treeExplVertical=1
let g:treeExplWinSize=35
let g:treeExplDirSort=1

""""""""""""""""""""""""""""""""""""
" MRU
""""""""""""""""""""""""""""""""""""
let MRU_File = '/home/qianli/.vim/.vim_mru_files'
let MRU_Max_Entries=20
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'
""""""""""""""""""""""""""""""""""""
" => Grep
""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F3> :Grep<CR>

""""""""""""""""""""""""""""""""
"vimblog
""""""""""""""""""""""""""""""""
if !exists('*Wordpress_vim')
runtime vimblog.vim
endif

""""""""""""""""""""""""""""""
"Gvim
""""""""""""""""""""""""""""""
if has("gui_running")
"gui
colorscheme desert
set guifont=Monaco\ 10
endif

"""""""""""""""""""""""""""""
"key binding
"""""""""""""""""""""""""""""
" To save, ctrl-s.
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

