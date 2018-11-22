set nocompatible
filetype off


" ==== Vundle ==== "
" Vundle (package manager) setup
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'

" Automatically matches parens, brackets, braces, etc.
Plugin 'Raimondi/delimitMate'

" Provides (semantic) autocomplete, C linting, etc.
Plugin 'Valloric/YouCompleteMe'

" Identifies and highlights superfluous whitespace
Plugin 'ntpeters/vim-better-whitespace'

" Colorful and informative status line
Plugin 'vim-airline/vim-airline'

" Fuzzy search
Plugin 'ctrlpvim/ctrlp.vim'

" Multiple cursor support for quick refactors
Plugin 'terryma/vim-multiple-cursors'

" File search
Plugin 'scrooloose/nerdtree'

" Quick surrounding character replacement (e.g. '"[{(<, etc)
Plugin 'tpope/vim-surround'

" Highlights indents
Plugin 'nathanaelkane/vim-indent-guides'

" Semantic code highlighting
Plugin 'jdkula/chromatica.nvim'

call vundle#end()


" ==== Vim Options ==== "

" Get and enable default file indents/plugins.
filetype plugin indent on

" Show line nubers
set number

" Turn on syntax highlighting
syntax on

" My color scheme of choice :)
colorscheme delek

" Highlights what you search for
set hlsearch

" Turns on incremental search (search-as-you-type)
set incsearch

" Turns on auto indentation
set autoindent

" Makes vim try to guess the next indentation level intelligently.
set smartindent

" Default tab width -- I like 4, but CS110 uses 2.
set tabstop=2
set shiftwidth=2

" Make tabs into spaces
set expandtab

" Wrap lines when moving around with the arrow keys or h/l
set whichwrap+=<,>,h,l,[,]

" Don't hard wrap lines.
set formatoptions=t

" Don't show lines as wrapped.
set nowrap

" Move around Vim with the mouse!
set mouse=a


" ==== Chromatica Options ==== "
let g:chromatica#enable_at_startup = 1
let g:chromatica#responsive_mode = 1
let g:chromatica#search_source_args = 1

" ==== YCM Options ==== "
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<S-TAB>']
let g:ycm_key_list_stop_completion = ['<C-y>', '<Enter>']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 0

" ==== NERDTree Options ==== "
" Automatically close NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '⯈'
let g:NERDTreeDirArrowCollapsible = '⯆'

" ==== vim-indent-guides Options ==== "
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0



" ==== Key Remaps ==== "
" Press jj to exit insert mode (easier than pressing Escape).
inoremap jj <ESC>

" Press enter when you're done searching to remove highlights
nnoremap <CR> :nohlsearch<CR><CR>

" Toggle wrap with \w
nnoremap <leader>w :set wrap!<CR>

" Skip to the next line with \o...
inoremap <leader>o <ESC>o

" ...or the previous with \O
inoremap <leader>O <ESC>O

" Press F2 to show a file browser
nnoremap <F2> :NERDTreeToggle<CR>

" Press Ctrl+g to skip to the declaration/etc of the term the cursor is over.
" (Press Ctrl+o to go back!)
nnoremap <C-g> :YcmCompleter GoTo<CR>

" Type \d to show the documentation for the term the cursor is over.
nnoremap <leader>d :YcmCompleter GetDoc<CR>

" Type \type to show the type for the term the cursor is over.
nnoremap <leader>type :YcmCompleter GetType<CR>

" Type \fix to try to automatically apply a fix for the issue the cursor is over.
nnoremap <leader>fix :YcmCompleter FixIt<CR>

" Press F5 to force YCM to recheck the file.
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
inoremap <F5> <ESC>:YcmForceCompileAndDiagnostics<CR>a

" Press F1 to show a window with all issues shown.
nnoremap <F1> :YcmDiags<CR>
inoremap <F1> <ESC>:YcmDiags<CR>

" Type \c to close any extra windows that are opened.
nnoremap <leader>c :ccl <bar> lcl <bar> pclose<CR>
inoremap <leader>c <ESC>:ccl <bar> lcl <bar> pclose<CR>a

" Press Ctrl+a/Ctrl+d to switch to the left/right tab.
nnoremap <C-a> :tabp<CR>
nnoremap <C-d> :tabn<CR>
inoremap <C-a> <ESC>:tabp<CR>i
inoremap <C-d> <ESC>:tabn<CR>i

" Press Ctrl+s to save
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>


" ==== Colors! ==== "
" Search highlighting
highlight Search cterm=underline ctermbg=22

" Line number highlighting
highlight LineNr ctermfg=244 ctermbg=233

" Shows a line at the 100th character (your line is probably too long if it gets here!)
set colorcolumn=100
highlight ColorColumn ctermbg=233

" == YCM Colors == "
highlight YcmErrorSign ctermfg=9 ctermbg=235
highlight YcmWarningSign ctermfg=11 ctermbg=235

highlight YcmErrorSection cterm=underline ctermfg=9 ctermbg=233
highlight YcmWarningSection cterm=underline ctermfg=227 ctermbg=233

highlight SignColumn ctermbg=232

" == Chromatica Colors == "
highlight chromaticaLinkage ctermfg=99

" == Ctrl+P Colors == "
highlight Pmenu ctermfg=15 ctermbg=235
highlight PmenuSel ctermfg=15 ctermbg=24


" == vim-indent-guides Colors == "
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=232
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=233
highlight ExtraWhitespace ctermbg=52

