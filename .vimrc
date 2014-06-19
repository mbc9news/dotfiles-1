" Author:        Josh Davis
" Description:   This is the personal .vimrc file of Josh Davis. I've tried to
"                document every option and item. Feel free to use it to learn
"                more about configuring Vim.
"
"                Also, I encourage you to pick out the parts that you use and
"                understand rather than blindly using it.
"
"                You can find me on Github: http://github.com/jdavis Or my
"                personal site: http://joshldavis.com

" As the help says 'Make vim behave in a more useful way'
" **Must be first uncommented line**
set nocompatible

"
" Determine the OS for OS specific code
"
let g:OS = 'linux'

let os = substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
    let g:OS = 'osx'
endif

"
" Custom Functions
"

" Switch between paste/nopaste
function! PasteToggle()
    if &paste
        set nopaste
    else
        set paste
    endif
endfunction

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
" Source: https://github.com/scrooloose/nerdtree/issues/21
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" Remove trailing whitespace
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<CR>
        normal `z
        retab
    endif
endfunction

" Function to hide all the text except for the text selected in visual mode.
" This is great for highlighting parts of the code. Just call the function
" again to deselect everything.
function! ToggleSelected(visual) range
    highlight HideSelected ctermfg=bg ctermbg=bg
                         \ guifg=bg guibg=bg gui=none term=none cterm=none

    if exists("g:toggle_selected_hide")
        call matchdelete(g:toggle_selected_hide)

        unlet g:toggle_selected_hide
        redraw

        if !a:visual
            return
        endif
    endif

    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]

    let pattern = '\%^\|\%<'.lnum1.'l\|\%<'.col1.'v\|\%>'.lnum2.'l\|\%>'.col2.'v'
    let g:toggle_selected_hide = matchadd('HideSelected', pattern, 1000)

    redraw
endfunction

" Check if a colorscheme exists
" http://stackoverflow.com/a/5703164
function! HasColorScheme(scheme)
    let path = '~/.vim/bundle/vim-colorschemes/colors/' . a:scheme . '.vim'
    return filereadable(expand(path))
endfunction

"
" Global Settings
"

" The default 20 isn't nearly enough
set history=9999

" Show the numbers on the left of the screen
set number

" Show the column/row
set ruler

" Highlight only the lines that go past 80 characters
highlight ColorColumn ctermbg=green guibg=green
call matchadd('ColorColumn', '\%82v', 100)

" Pretty colors are fun, yayyy
syntax on

" Show the matching when doing a search
set showmatch

" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start

" Ignore case when doing a search as well as highlight it as it is typed
set ignorecase smartcase
set hlsearch
set incsearch

" Don't show the startup message
set shortmess=I

" Show the current command at the bottom
set showcmd

" Disable beeping and flashing.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Use smarter defaults
set smartindent
set smarttab

" Use autoindenting
set autoindent

" The tabstop look best at 4 spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4

" I have been converted to the dark side, I will use spaces to indent code
" from here on out
set expandtab

" Buffer Settings
set hidden

" Turn on persistent undo
" Thanks, Mr Wadsten: github.com/mikewadsten/dotfiles/
if has('persistent_undo')
    set undodir=~/.vim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" Use backups
" Source:
"   http://stackoverflow.com/a/15317146
set backup
set writebackup
set backupdir=~/.vim/backup//

" Use a specified swap folder
" Source:
"   http://stackoverflow.com/a/15317146
set directory=~/.vim/swap//

" The comma makes a great leader of men, heh heh
let mapleader = ','
let maplocalleader = '\'

" Show two lines for the status line
set laststatus=2

" Always show the last line
set display+=lastline

" UTF-8 THIS SHITTTTTT
set encoding=utf-8

" Enhanced mode for command-line completion
set wildmenu

" Automatically re-read the file if it has changed
set autoread

" Fold Settings

" Off on start
set nofoldenable

" Indent seems to work the best
set foldmethod=indent

"
" Global Bindings
"

" Show only selected in Visual Mode
nmap <silent> <leader>th :cal ToggleSelected(0)<CR>
vmap <silent> <leader>th :cal ToggleSelected(1)<CR>

" Split the window using some nice shortcuts
nmap <leader>s<bar> :vsplit<cr>
nmap <leader>s- :split<cr>

" Unhighlight the last search pattern on Enter
nn <silent> <CR> :nohlsearch<CR><CR>

" Remove trailing whitespace
nmap <leader>tW :cal StripTrailingWhitespace()<CR>

" Control enhancements in insert mode
imap <C-F> <RIGHT>
imap <C-B> <LEFT>
imap <M-BS> <ESC>vBc
imap <C-P> <UP>
imap <C-N> <DOWN>

" When pushing j/k on a line that is wrapped, it navigates to the same line,
" just to the expected location rather than to the next line
nnoremap j gj
nnoremap k gk

" Arrow key users won't survive in this environment
map <UP> <NOP>
map <DOWN> <NOP>
map <LEFT> <NOP>
map <RIGHT> <NOP>

" Map Ctrl+V to paste in Insert mode
imap <C-V> <C-R>*

" Map Ctrl+C to copy in Visual mode
vmap <C-C> "+y

" Add paste shortcut
nmap <leader>P "+p

" GVim Settings
if has('gui_running')
    " Who uses a GUI in GVim anyways? Let's be serious.
    set guioptions=aegirLt

    " Let's make the fonts look nice
    if g:OS == 'osx'
        set guifont=Droid\ Sans\ Mono\ for\ Powerline:h11
    elseif g:OS == 'linux'
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
    endif
endif

" Fold Keybindings
"nnoremap <Space> za

"
" Custom Settings
"

" Set on textwidth when in markdown files
autocmd FileType markdown set textwidth=80

" Smarter completion in C
autocmd FileType c set omnifunc=ccomplete#Complete

" My own special flavoring to running programs
autocmd FileType asm,c,objc,scheme,sh,python,perl,javascript nn <leader>R :!~/Scripts/deepThought.sh '%:p'<CR>

" Use 2 spaces when in Lua & Ruby
autocmd FileType lua,ruby set tabstop=2
autocmd FileType lua,ruby set shiftwidth=2

" Show trailing whitespace and tabs obnoxiously
set list listchars=tab:>-,trail:.,extends:>
set list

"
" Start Vundle
"

" Required by Vundle
filetype off

" Vundle is the new god among plugins
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"
" Vundle Bundles + Settings
"

"
" Vundle: Plugin management
"

" Vundle bundle
Plugin 'gmarik/vundle'

" Vundle mapping
nmap <leader>vl :BundleList<cr>
nmap <leader>vi :BundleInstall<cr>
nmap <leader>vI :BundleInstall!<cr>
nmap <leader>vc :BundleClean<cr>
nmap <leader>vC :BundleClean!<cr>

"
" Vim + Git
"

" Updated Vim-Git runtime files
Plugin 'tpope/vim-git'

" Git Gutter
Plugin 'airblade/vim-gitgutter'

" Vim and Git, sayyyy whatttt
Plugin 'tpope/vim-fugitive'

" Fugitive mapping
nmap <leader>gb :Gblame<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gg :Ggrep
nmap <leader>gl :Glog<cr>
nmap <leader>gp :Git pull<cr>
nmap <leader>gP :Git push<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gbrowse<cr>

"
" File Management
"

" For file browsing
Plugin 'scrooloose/nerdtree'

" NERDTree Options: Toggle Browser
let NERDTreeIgnore = ['\.py[co]$', '\.sw[po]$', '\.class$', '\.aux$']
nmap <leader>tb :NERDTreeToggle<cr>

" Close NERDTree if it is the last buffer open
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Automatically open NERDTree whenever opened with GUI
if has('gui_running')
    autocmd VimEnter * NERDTree
    autocmd VimEnter * wincmd p
endif

" Various commenting capabilities
Plugin 'scrooloose/nerdcommenter'

" Automatically close things
Plugin 'Raimondi/delimitMate'

" For checking the syntax of any file
Plugin 'scrooloose/syntastic'

" Syntastic Settings
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_signs = 1
let g:syntastic_java_checkers = ["checkstyle", "javac"]
let g:syntastic_java_javac_delete_output = 1
let g:syntastic_java_checkstyle_conf_file = '~/bin/jars/sun_checks.xml'
let g:syntastic_java_checkstyle_classpath = '~/bin/jars/checkstyle-5.5-all.jar'
let g:syntastic_filetype_map = { 'rnoweb': 'tex'}


" For fuzzyfinding
Plugin 'kien/ctrlp.vim'

" CtrlP Settings
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use nearest .git dir
let g:ctrlp_working_path_mode = 'r'

nmap <leader>p :CtrlP<cr>

" Buffer controls to go with Buffergator
nmap <leader>bb :CtrlPBuffer<CR>
nmap <leader>bm :CtrlPMixed<CR>
nmap <leader>bs :CtrlPMRU<CR>

" Easily surround things
Plugin 'tpope/vim-surround'

" For better status lines
Plugin 'bling/vim-airline'

" Airline options
let g:airline_enable_branch = 1
let g:airline_enable_syntastic = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'light'

"
" Language Bundles
"

" Better JavaScript support
Plugin 'pangloss/vim-javascript'


" Let's add some colors
Plugin 'flazz/vim-colorschemes'

" For CoffeeScript, YAY!
Plugin 'kchmck/vim-coffee-script'

" For LESS
Plugin 'groenewege/vim-less'

" Better Markdown
Plugin 'tpope/vim-markdown'

" Rust-Lang Features
Plugin 'wting/rust.vim'

" Stylus Plugin
Plugin 'wavded/vim-stylus'

"
" Misc Bundles
"

" Vim-bad-whitespace, highlights bad whitespace
Plugin 'bitc/vim-bad-whitespace'

" Add Gist-vim
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" Easymotion
Plugin 'Lokaltog/vim-easymotion'

map <space> <Plug>(easymotion-prefix)

let g:EasyMotion_smartcase = 1
map <space>h <Plug>(easymotion-lineforward)
map <space>j <Plug>(easymotion-j)
map <space>k <Plug>(easymotion-k)
map <space>l <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0

" Awesome plugin for my capitalization woes:
" http://www.reddit.com/r/vim/comments/1im4d9/c/cb6906n
Plugin 'takac/vim-commandcaps'

" Long live ctags
Plugin 'majutsushi/tagbar'

" Tagbar Options
" Toggle Tagbar
nmap <leader>tt :TagbarToggle<CR>
let g:tagbar_left = 0
let g:tagbar_width = 30

" Ack support in Vim
Plugin 'mileszs/ack.vim'

let g:ackpreview = 2
"let g:ack_autoclose = 1
let g:ackhighlight = 1
nmap <leader>/ :Ack!<space>

" Better Undo
Plugin 'mbbill/undotree'

" Undotree settings
nmap <leader>tu :UndotreeToggle<CR>
let g:undotree_SplitWidth = 30
let g:undotree_WindowLayout = 3

" Better Session Management
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-misc'

" Vim-Session Settings
let g:session_autosave_periodic = 5
let g:session_directory = '~/.vim/sessions/'
let g:session_command_aliases = 1
let g:session_autosave = 'yes'

nmap <leader>Ss :SaveSession
nmap <leader>So :OpenSession
nmap <leader>Sr :RestartVim<cr>
nmap <leader>Sc :CloseSession<cr>
nmap <leader>SC :CloseSession!<cr>
nmap <leader>Sd :DeleteSession
nmap <leader>SD :DeleteSession!
nmap <leader>Sv :ViewSession

" Vim-Racket
Plugin 'wlangstroth/vim-racket'

" Multiple Cursors like Sublime
Plugin 'terryma/vim-multiple-cursors'

" Multiple Cursors Settings
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = '<C-j>'
let g:multi_cursor_prev_key = '<C-k>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = '<Esc>'

" Vimux
Plugin 'jdavis/vimux'

" Syntax Range for Vimdeck
Plugin 'vim-scripts/SyntaxRange'

" R for Vim
Plugin 'jalvesaq/VimCom'
Plugin 'jcfaria/Vim-R-plugin'

" Worthless mapping
let g:vimrplugin_assign = 0

" Disable ridiculous mappings
let g:vimrplugin_insert_mode_cmds = 0

" Scala for Vim
Plugin 'derekwyatt/vim-scala'

" The powers of Gitignore + wildignore combine!
" Originally written by @zdwolfe, updated by @mikewadsten
"Bundle 'mikewadsten/vim-gitwildignore'

" GitHub Issues + Vim
"Bundle 'jaxbot/github-issues.vim'

" Vim + LaTeX
Plugin 'LaTeX-Box-Team/LaTeX-Box'

" LaTex-Box Settings
let g:LatexBox_latexmk_async = 1
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer = 'open -a Skim.app'
let g:LatexBox_viewer = 'mate-open'

" Ultisnips plugin
Plugin 'SirVer/ultisnips'

" Grab some snippets
Plugin 'honza/vim-snippets'

nmap <leader>U :call UltiSnips#ListSnippets()<cr>

" Complete UltiSnip snippets with <tab>
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Moonscript
Plugin 'leafo/moonscript-vim'

" Smart indenting
"Bundle 'tpope/vim-sleuth'

" Buffer management
Plugin 'jeetsukumaran/vim-buffergator'

" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1

" Looper!
"let g:buffergator_mru_cycle_loop = 1

nmap <leader>T :enew<cr>
nmap <C-h> :BuffergatorMruCyclePrev<CR>
nmap <C-l> :BuffergatorMruCycleNext<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :BuffergatorOpen<CR>

" YCM
Plugin 'Valloric/YouCompleteMe'

" Use extra conf file
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" Ignore certain filetypes
let g:ycm_filetype_blacklist = {
\ 'tagbar': 1,
\ 'qf': 1,
\ 'notes': 1,
\ 'markdown': 1,
\ 'unite': 1,
\ 'text': 1,
\ 'vimwiki': 1,
\ 'pandoc': 1,
\ 'infolog': 1,
\ 'mail': 1,
\ 'gitcommit': 1,
\}

"
" Custom Bindings
"

" Bind PasteToggle to something quick and easy
nmap <leader>tP :cal PasteToggle()<cr>

" Bind :sort to something easy, don't press enter, allow for options (eg -u,
" n, sorting in reverse [sort!])
vnoremap <leader>s :sort

"
" Vimux Settings
"

if has('gui_running')
    let g:VimuxUseNearest = 1
    let g:VimuxRunnerType = 'window'
else
    let g:VimuxUseNearest = 0
    let g:VimuxRunnerType = 'pane'
endif

let g:VimuxPromptString = 'tmux > '

"
" Vimux Functions
" I could make a plugin out of these...
"

function! VimuxSetupRacket()
    call VimuxRunCommand('racket -il readline')
    call VimuxClearRunnerHistory()
endfunction

function! VimuxQuitRacket()
    call VimuxInterruptRunner()
    call VimuxCloseRunner()
endfunction

function! VimuxRunSelection() range
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]

    let lines = getline(lnum1, lnum2)

    let lines[-1] = lines[-1][: col2 - 1]
    let lines[0] = lines[0][col1 - 1:]

    call VimuxRunCommand(join(lines, "\n"))
endfunction

function! VimuxRunLine()
    call VimuxRunCommand(getline('.'))
endfunction

function! VimuxRunParagraph()
    let [lnum1] = getpos("'{")[1:1]
    let [lnum2] = getpos("'}")[1:1]

    let lines = getline(lnum1, lnum2)
    let filtered = filter(lines, 'v:val !~ "^\s*;"')

    call VimuxRunCommand(join(filtered, ''))
endfunction

"
" Vimux Bindings
"

" Setup autocmd if Racket filetype
autocmd FileType racket call SetupVimuxRacket()

function! SetupVimuxRacket()
    set shiftwidth=2

    " Start interpretter
    nmap <silent> <localleader>ri :call VimuxSetupRacket()<CR>
    nmap <silent> <localleader>rq :call VimuxQuitRacket()<CR>
    nmap <silent> <localleader>rl :call VimuxRunLine()<CR>
    nmap <silent> <localleader>R :call VimuxRunParagraph()<CR>
    nmap <silent> <localleader>rp :call VimuxRunParagraph()<CR>
    vmap <silent> <localleader>R :call VimuxRunSelection()<CR>
endfunction

"
" Misc Settings
"

" Let's make it pretty
set background=dark
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

" Must be loaded after the vim-colorschemes bundle
if HasColorScheme('moria')
    colorscheme moria
endif

" Load plugins and indent for the filtype
" **Must be last for Vundle**
filetype plugin indent on
