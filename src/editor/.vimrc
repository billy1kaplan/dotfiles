filetype on
syntax on
set number relativenumber
set shiftround
filetype plugin indent on

set tabstop=4
set shiftwidth=4

set expandtab
set smartindent
set autoindent

augroup spacing
  autocmd FileType html setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby setlocal ts=2 sts=2 sw=2
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2
  autocmd FileType javascriptreact setlocal ts=2 sts=2 sw=2
  autocmd FileType python setlocal ts=4 sts=4 sw=4
  autocmd FileType lua setlocal ts=4 sts=4 sw=4
  autocmd FileType vim setlocal ts=2 sts=2 sw=2
  autocmd FileType json setlocal ts=2 sts=2 sw=2
  autocmd FileType scss setlocal ts=2 sts=2 sw=2
augroup END

set backspace=indent,eol,start
echo ">^.^<"

" Mappings
let mapleader = " "
let maplocalleader = ";"

inoremap <c-u> <esc>viwUea
noremap <leader><c-u> viwUe
nnoremap <leader>ev :split ~/.vimrc<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

iabbrev @@ billy@relevant.healthcare
iabbrev waht what

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader><s-h> 0
nnoremap <leader><s-l> $

nnoremap <leader>wj <c-w>j
nnoremap <leader>wk <c-w>k
nnoremap <leader>wl <c-w>l
nnoremap <leader>wh <c-w>h

" " Copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>p "+P

" Tab to move between buffers
nnoremap  <tab> :bnext<cr>
nnoremap  <s-tab> :bprevious<cr>",

" autocmds
autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
" autocmd FileType markdown setlocal spell spelllang=en_us

function! ToggleTestPath()
  let l:path = expand('%:p')
  if (l:path=~'/app/')
    let l:after = substitute(substitute(l:path, ".rb", "_spec.rb", ""), "/app/", "/spec/", "")
    exe ":edit " l:after
  else
    let l:after = substitute(substitute(l:path, "_spec.rb", ".rb", ""), "/spec/", "/app/", "")
    exe ":edit " l:after
  endif
endfunction

" Ruby autocmds
augroup rubygroup
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <localleader>c I# <esc>
  autocmd FileType ruby nnoremap <buffer> <localleader>gt :call ToggleTestPath()<cr>
  autocmd FileType ruby :iabbrev <buffer> return USERET
  autocmd FileType ruby :iabbrev <buffer> ret return
  autocmd FileType ruby nnoremap <buffer> <localleader>c I# <esc>
  autocmd FileType ruby nnoremap <buffer> <localleader>t :TestFile<cr>
augroup END

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Movement Remapping
onoremap p i(
" Hacky email search and change
onoremap in@ :<c-u>execute "normal! /\\w\\+@\\w\\+\\.\\w\\+\r:nohlsearch\rgn"<cr>

" Statusline
set statusline =%f      " Path to the file
set statusline+=%=      " Switch to the right side
set statusline+=%{readfile('/Users/billy/.weather')[0]}      " Weather because why not
set statusline+=%l      " Current line
set statusline+=/       " Separator
set statusline+=%L      " Total lines

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "
call plug#begin('~/.vim/plugged')
" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" IDE Features
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" Vim in the Browser 
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Terminal Support
Plug 'kassio/neoterm'

" Testing
Plug 'vim-test/vim-test'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Multifile find and replace
Plug 'mhinz/vim-grepper'

" Those nice devicons - <!> Always Install This Last <!>
" Plug 'ryanoasis/vim-devicons'
call plug#end()

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

call denite#custom#var('grep', 'command', ['rg'])

call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "
" === Denite Keymappings === "
"   <leader>b     - Browse currently open buffers
nmap <leader>b :Denite buffer<cr>

"   <leader>t     - Browse list of ffiles in current directory
nmap <leader>t :DeniteProjectDir file/rec<cr>

"   <leader>f     - Search current directory for occurences of regex
nnoremap <leader>f :<c-u>Denite grep:. -no-empty<cr>

"   <leader>j     - Search current directory for occurence of word under
"   cursor
nnoremap <leader><s-f> :<c-u>DeniteCursorWord grep:.<cr>

" Define 'filter' mode mappings
"   <c-o>         - Switch to normal mode inside of search results
"   <esc>         - Exit denite window in any mode
"   <cr>          - Open currently selected file in any mode
"   <c-t>         - Open currently selected file in a new tab
"   <c-v>         - Open currently selected file a vertical split
"   <c-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <c-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <cr>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <cr>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <cr>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}


" === Coc Keymappings === "
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

"   <leader>gd    - Jump to definition of current symbol
"   <leader>gg    - Jump to references of current symbol
"   <leader>gt    - Jump to implementation of current symbol
"   <leader>gf    - Fuzzy search current project symbols
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gg <Plug>(coc-references)
nmap <silent> <leader>gt <Plug>(coc-implementation)
nnoremap <silent> <leader>gf :<C-u>CocList -I -N --top symbols<CR>

" .............................................................................
" mhinz/vim-grepper
" .............................................................................

let g:grepper={}
let g:grepper.tools=["rg"]

xmap gr <plug>(GrepperOperator)

" After searching for text, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" The same as above except it works with a visual selection.
xmap <Leader>R
    \ "sy
    \ gvgr
    \ :cfdo %s/<C-r>s//g \| update
     \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" Integrated Terminal
set splitright
set splitbelow

" Escape to get to normal mode in terminal
tnoremap <esc> <c-\><c-n>

au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" open terminal
let g:neoterm_autoscroll = 1      " autoscroll to the bottom when entering insert mode
let g:neoterm_size = 10
let g:neoterm_fixedsize = 1       " fixed size. The autosizing was wonky for me
let g:neoterm_keep_term_open = 0  " when buffer closes, exit the terminal too.
let g:neoterm_default_mod = 'botright'

function! OpenTerminal()
  split term://zsh
endfunction
nnoremap <leader>s :Tnew<cr>

let test#strategy='neoterm'

" Splitting
nnoremap <leader>w- :split<cr>
nnoremap <leader>w/ :vsplit<cr>

set swapfile
set dir=~/tmp
