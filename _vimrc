set nocompatible "禁用对vi的兼容,否则vim的高级功能很多不能用

"颜色
syntax on "开启语法高亮,否则代码关键字没有颜色
set t_Co=256 "颜色深度,让色彩更丰富
colors molokai "我最喜欢的配色方案

"文件
set encoding=utf8 "默认编码,可能不需要?
set autoread "文件更新后自动读取
set noswapfile "禁用swap文件
set autochdir "自动切换当前目录
set wildignore=*.o,*~,*.pyc " Ignore compiled files

"Tab
set expandtab
set smarttab
set tabstop=4

"缩进
set shiftwidth=4
set autoindent
set smartindent

"代码
set nowrap "不自动换行
"set wrap
set ruler
set number
set cursorline

"Search
set incsearch " search while type
set hlsearch " highlight search
set so=5 " while mv with j or k, the page will start mv 5 lines before the bottom or top

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
nmap <leader>w :w!<cr> " Fast saving
nmap <leader>x :x<cr>  " Fast exit
nmap <leader>e :e!<cr>  " Fast reload
nmap <leader>h :noh<cr>  " Fast rm highlight

" map ; to :, make cmd easy
nnoremap ; :

" tab navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tn :tabnew<CR>
nnoremap tc :tabclose<CR>
nnoremap tm :tabmove<CR>
nnoremap to :tabonly<CR> " close other tabs

" window nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l   

" plugs
" Enable filetype plugins
filetype plugin on
filetype indent on

nnoremap tt :NERDTreeToggle<CR>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.html :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" auto load vimrc if change
autocmd! bufwritepost _vimrc source %

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
