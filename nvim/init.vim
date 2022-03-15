
" ------------------------------------------------------
" Core Keybindings
" ------------------------------------------------------
let mapleader = ","

" Refresh vimrc
nmap <leader><leader>r :source ~/.vimrc<cr>

" Toggle numbering
nmap <leader><leader>n :set number!<cr>

" Better than escape
imap jk <ESC>

" Create blank lines
nmap go o<ESC>
nmap gO O<ESC>

" Movement
nmap J 5j
nmap K 5k
nnoremap <leader><c-e> <c-e>
nnoremap <leader><c-y> <c-y>
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>

" Panes
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-w>q :close<CR>

" Tabs
nmap ts :tab split<CR>
nmap tk :tabnext<CR>
nmap tj :tabprevious<CR>

" Replacement commands
nmap <leader>r yiw:%s/\<<C-r>"\>//gc<left><left><left>
nmap <leader>R <ESC>:%s///gc<left><left><left><left>
vmap <leader>r y<ESC>:%s/<C-r>"//gc<left><left><left>
vmap <leader>R <ESC>:%s/\%V//gc<left><left><left><left>

" ------------------------------------------------------
" Core settings
" ------------------------------------------------------
filetype plugin indent on
syntax enable
syntax on
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
set hidden
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set splitright
set splitbelow
set hlsearch
set smartindent
set smarttab

"set autoread
autocmd FileType * setlocal formatoptions-=cro
autocmd FileType python set shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType pyrex set shiftwidth=2 tabstop=2 softtabstop=2

let g:python3_host_prog = '/home/ddineen/.local/miniconda3/envs/neovim/bin/python'
set tags=./.tags

" ------------------------------------------------------
" On save
" ------------------------------------------------------
":autocmd BufWritePre *.cpp !/opt/rh/llvm-toolset-7/root/usr/bin/clang-format -style=Google -i %:p
":autocmd BufWritePost *.hpp !/opt/rh/llvm-toolset-7/root/usr/bin/clang-format -style=Google -i %:p


" ------------------------------------------------------
" Core Extensions
" ------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rhysd/vim-clang-format'
Plug 'joshdick/onedark.vim'
Plug 'google/yapf'
Plug 'vim-airline/vim-airline'
Plug 'craigemery/vim-autotag'
call plug#end()


" ------------------------------------------------------
" Color
" ------------------------------------------------------
" set cursorline
colorscheme desert
highlight clear SignColumn

" hi CursorLine term=bold cterm=bold
" hi CursorLineNr term=bold cterm=bold 
" hi CursorLine term=bold cterm=bold ctermbg=235
" hi CursorLineNr term=bold cterm=bold ctermbg=235
" hi Normal ctermbg=none ctermfg=251
" hi Visual cterm=bold
" hi NonText ctermbg=none


" ------------------------------------------------------
" Clang Format
" ------------------------------------------------------
let g:clang_format#command = "/usr/local/omc-clang/bin/clang-format"
let g:clang_format#auto_format = 1
let g:clang_format#style = "file"
autocmd FileType javascript :ClangFormatAutoDisable
autocmd FileType proto :ClangFormatAutoDisable


" ------------------------------------------------------
" Conquer of Completion
" ------------------------------------------------------
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
hi Pmenu ctermbg=11 guibg=DarkGrey
let g:airline#extensions#coc#enabled = 0
let g:coc_global_extensions = ['coc-prettier', 'coc-highlight', 'coc-pyright']


" ------------------------------------------------------
" FZF
" ------------------------------------------------------
let g:fzf_command_prefix = 'Fzf'
nmap <C-p> :FzfFiles<CR>
nmap <SPACE>t :FzfBTags<CR>
nmap <C-l> :FzfBTags<CR>
nmap <SPACE>T :FzfTags<CR>
nmap <SPACE>b :FzfBuffers<CR>
let g:fzf_buffers_jump = 1


" ------------------------------------------------------
" YAPF
" ------------------------------------------------------
let g:yapf_enabled = 1

python3 << endpython3
import vim
import subprocess
from time import time

def format_with_yapf():
  enabled = int(vim.eval("g:yapf_enabled"))
  if not enabled:
    return

  start = time()
  buf = "\n".join(vim.current.buffer) + "\n"
  with subprocess.Popen([
    "yapf",
    "--style",
    "/etc/style.yapf",
    ],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE) as proc:
    out, err = proc.communicate(buf.encode())

  if proc.returncode != 0:
    print("yapf failure: rc={rc}, output: {err}".format(
      rc=proc.returncode,
      err=err.decode()))
    return

  # Adapted from Black's vim plugin
  current_buffer = vim.current.window.buffer
  cursors = []
  for i, tabpage in enumerate(vim.tabpages):
    if not tabpage.valid:
      continue
    for j, window in enumerate(tabpage.windows):
      if not window.valid or window.buffer != current_buffer:
        continue
      cursors.append((i, j, window.cursor))

  vim.current.buffer[:] = out.decode().split("\n")[:-1]
  for i, j, cursor in cursors:
    window = vim.tabpages[i].windows[j]
    try:
      window.cursor = cursor
    except vim.error:
      window.cursor = (len(window.buffer), 0)

  elapsed = time() - start
  print("Reformatted with Yapf in {elapsed:.3f} sec.".format(**locals())) 

endpython3

augroup Yapf
  autocmd BufWritePre *.py,SConstruct,SConscript :py3 format_with_yapf()
augroup END

