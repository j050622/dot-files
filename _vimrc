" Sections:
"    => Bundles
"    => General
"    => Text, tab and indent related
"    => Colors and Fonts
"    => Helper functions
"    => Mappings
"    => Buffers
"    => Conversion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Bundles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Required!
filetype off

" Enable filetype plugins
filetype plugin on
filetype indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fencs=utf-8,gbk

" Encoding dectection
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1

" Use Unix as the standard file type
set ffs=unix,dos,mac

if has("win32")
    set fileencoding=chinese
    set guifont=Consolas:h10

    set guioptions+=lrbmTLce
    set guioptions-=lrbmTLce
    set guioptions+=c

    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    language message zh_CN.utf-8

    " Use ~x on an English Windows version or ~n for French
    au GUIEnter * simalt ~x
else
    set fileencoding=utf-8
endif

" Enable syntax highlight and completion
syntax on

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch

" Editor settings
set history=1000
set tm=2000                        " leader key timeout
set nofoldenable                   " disable folding"
set confirm                        " prompt when existing from an unsaved file
set backspace=indent,eol,start     " more powerful backspacing
set t_Co=256                       " explicitly tell vim that the terminal has 256 colors
set mouse=a                        " use mouse in all modes
set report=0                       " always report number of lines changed
set nowrap                         " dont wrap lines
set scrolloff=5                    " 5 lines above/below cursor when scrolling
set number                         " show line numbers
set showmatch                      " show matching bracket (briefly jump)
set showcmd                        " show typed command in status bar
set title                          " show file in titlebar
set laststatus=2                   " use 2 lines for the status bar
set matchtime=2                    " show matching bracket for 0.2 seconds
set matchpairs+=<:>                " specially for html
set autoread                       " set to auto read when a file is changed from the outside
set lazyredraw                     " don't redraw while executing macros (good performance config)
set magic                          " for regular expressions turn magic on
set foldcolumn=1                   " add a bit extra margin to the left
set backspace=eol,start,indent     " it acts as it should act
set wildmenu                       " wildmenu
set wildmode=longest,list,full     " tab complete files up to longest unambiguous prefix
set so=7                           " set 7 lines to the cursor - when moving vertically using j/k
set cc=80                          " color the 80th column
set foldmethod=syntax              " fold by syntax
set whichwrap+=<,>,h,l

" Show trailing whitespace
set list
" But only interesting whitespace
if &listchars ==# 'eol:$'
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Turn backup off, since most stuff is in Git anyway...
set nobackup
set nowb
set noswapfile

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent
set smartindent   " indent when
set tabstop=4     " tab width
set softtabstop=4 " backspace
set shiftwidth=4  " indent width
set expandtab     " expand tab to space
set smarttab
set formatoptions+=mM

" Linebreak on 500 characters
set lbr
set textwidth=500

augroup lang_config
    autocmd!
    autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
    autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
    autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
    autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
    autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
    autocmd BufEnter Makefile setlocal noexpandtab
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    color DarkDefault
catch
    colorscheme desert
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! SetColorColumn()
    let col_num = virtcol(".")
    let cc_list = split(&cc, ',')
    if count(cc_list, string(col_num)) <= 0
        exe "set cc+=" . col_num
    else
        exe "set cc-=" . col_num
    endif
endfunc

func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

" MyNext() and MyPrev(): Movement between tabs OR buffers
func! MyNext()
    if exists('*tabpagenr') && tabpagenr('$') != 1
        normal gt
    else
        exe ":bnext"
    endif
endfunc

func! MyPrev()
    if exists('*tabpagenr') && tabpagenr('$') != '1'
        normal gT
    else
        exe ":bprev"
    endif
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cmap w!! w !sudo tee >/dev/null %

" Allow the normal use of "," by pressing it twice
noremap ,, ,

nnoremap ; :
noremap <leader>; ;
cmap W w
cmap WQ wq
cmap Wq wq
cmap Q q
cmap Qa qa
cmap QA qa

if exists("$TMUX") == 0
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
endif

" Fix <Up> and <Down> keys inserting A B character
inoremap <Esc>OA <Esc>ki
inoremap <Esc>OB <Esc>ji
inoremap <Esc>OC <Right>
inoremap <Esc>OD <Left>

" Treat long lines as break lines (useful when moving around in them)
nnoremap j gj
nnoremap k gk

nnoremap <leader>hc :call SetColorColumn()<CR>
nnoremap <leader>dt :call DeleteTrailingWS()<CR>

" Force redraw
map <silent> <leader>r :redraw!<CR>

" Toggle spell checking
map <leader>ss :setlocal spell!<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Open file prompt with current path
nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>

" Disable highlight when <leader><CR> is pressed
" But preserve cursor coloring
map <silent> <leader><CR> :noh<CR>:hi Cursor ctermbg=red guibg=red<CR>

" Mappings for translation of snippets between multi Vim
vnoremap <leader>tee :!tee /tmp/t<CR>
vnoremap <leader>cat :!cat /tmp/t<CR>

" Movement between tabs OR buffers
nnoremap Q :call MyPrev()<CR>
nnoremap W :call MyNext()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight current line
autocmd WinLeave * set nocursorline nocursorcolumn
autocmd WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" Always show the status line
set laststatus=2

" Statusline
set statusline=
            \\ %F%m%r%h%w\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
            \%=%(%{&ff}:%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")
            \\ &&\ &bomb)?\",B\":\"\")}%k\ \|\ %Y\ \|
            \\ Buffer%0*\ %n%*%)\ \|\ %([%l,%v][%p%%][LEN=%L]\ %)

" Clear column highlight theme
highlight clear SignColumn

" Delete trailing whitespace
augroup whitespace
    autocmd!
    autocmd BufWrite *.lua,*.pl,*.py,*.rb,*.md
        \ :call DeleteTrailingWS()
augroup END

" Source the vimrc file after saving it
augroup sourcing
    autocmd!
    autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

" Return to last edit position when opening files (You want this!)
augroup last_edit
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

" Limit git commit message length
autocmd Filetype gitcommit setlocal spell textwidth=72

" Add underline when length exceed 81
autocmd BufRead,BufNewFile *.lua,*.c,*.py,*.sh,*.pl,*.rb,*.erb 2match Underlined /.\%81v/


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Conversion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convert symbol to string
nnoremap <silent> <leader>2s F:r"Ea"<Esc>
" Convert string to symbol
nnoremap <silent> <leader>2y F"r:,x

" Convert name to snake_case
nmap <leader>2_ cr_
" Convert name to camelCase
nmap <leader>2c crc
" Convert name to MixedCase
nmap <leader>2m crm
" Convert name to SNAKE_UPPERCASE
nmap <leader>2u cru
" Convert name to dash-case
nmap <leader>2- cr-
