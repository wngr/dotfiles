call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()
filetype plugin indent on
colorscheme peachpuff

au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Set text width for markdown files
au BufRead,BufNewFile *.md setlocal textwidth=120
autocmd BufRead,BufNewFile *.md setlocal spell
:set spelllang=en,de

"CTRL-t to toggle tree view with CTRL-t
nmap <silent> <C-t> :NERDTreeToggle<CR>
"Set F2 to put the cursor to the nerdtree
nmap <silent> <F2> :NERDTreeFind<CR>
:set expandtab
:set tabstop=2
" Show matching bracket
set showmatch
set matchtime=2
set shiftwidth=2
:set sw=2
:set number
syntax on
set cmdheight=2

" CtrlP using ripgrep
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif
nnoremap <C-p> :CtrlPCurWD<CR>


" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

let mapleader = ","

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <Leader>li <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>lo <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>lf :call CocAction('format')<CR>
nmap <Leader>ld <Plug>(coc-definition)
nmap <Leader>lt <Plug>(coc-type-definition)
nmap <Leader>lx <Plug>(coc-references)
nmap <Leader>lr <Plug>(coc-rename)
nmap <Leader>lk :call <SID>show_documentation()<CR>
nmap <Leader>ls :<C-u>CocList -I symbols<cr>

"nnoremap <Leader>lr :call LanguageClient#textDocument_rename()<CR>
"nnoremap <Leader>la :call LanguageClient_workspace_applyEdit()<CR>
"nnoremap <Leader>le :call LanguageClient#explainErrorAtPoint()<CR>
"nnoremap <Leader>lc :call LanguageClient#textDocument_completion()<CR>
"nnoremap <Leader>lh :call LanguageClient#textDocument_hover()<CR>
"nnoremap <Leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
"nnoremap <Leader>lm :call LanguageClient_contextMenu()<CR>


