source ~/.vim/basic.vim


" What else do we like?
"
set number


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of init.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :e! ~/.config/nvim/init.vim<cr>
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim



call plug#begin(stdpath('data') . '/plugged')

" Here is where we put the plugins we're going to use...
"
" Code formatter..
Plug 'sbdchd/neoformat'
"
" 
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'dracula/vim', { 'as': 'dracula' } 

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/completion-nvim'

" Install snippet engine (This example installs [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip))
" Plug 'hrsh7th/vim-vsnip'

" Install the buffer completion source
" Plug 'hrsh7th/cmp-buffer'

Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'

Plug 'kdheepak/lazygit.nvim'


Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'hoob3rt/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'ryanoasis/vim-devicons'

Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'mileszs/ack.vim'

Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }


" Initialize plugin system
call plug#end()

colorscheme dracula

lua << EOF
require'lspconfig'.tsserver.setup{}
EOF


" Plug 'hoob3rt/lualine.nvim' {{{
lua << EOF
require('plenary.reload').reload_module('lualine', true)
require('lualine').setup({
  options = {
    theme = 'dracula',
    disabled_types = { 'NvimTree' }
  },
  sections = {
    lualine_x = {},
    -- lualine_y = {},
    -- lualine_z = {},
  }
})
EOF
" }}}

lua require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

lua << EOF
local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF


" Here are the mappings for lspsaga....
"
"
" lsp provider to find the cursor word definition and reference
nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
" code action
nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
" show hover doc
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
" show signature help
nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
" rename
nnoremap <silent>gr <cmd>lua require('lspsaga.rename').rename()<CR>
" close rename win use <C-c> in insert mode or `q` in noremal mode or `:q`
" preview definition
nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
" show
nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
" only show diagnostic if cursor is over the area
nnoremap <silent><leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>

" jump diagnostic
nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
" float terminal also you can pass the cli command in open_float_terminal function
nnoremap <silent> <leader>g <cmd>lua require('lspsaga.floaterm').open_float_terminal('lazygit')<CR>
tnoremap <silent> <leader>T <cmd>lua require('lspsaga.floaterm').close_float_terminal()<CR>
" float terminal window...
nnoremap <silent> <leader>t <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>


lua << EOF
  require("trouble").setup {
  }
EOF

lua require'nvim-tree'.setup {}


"Telescope setup
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-f> <cmd>Telescope live_grep<cr>
nnoremap <C-b> <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

" nvim-treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'html', 'javascript', 'typescript', 'tsx', 'css', 'json'
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = false
  },
  context_commentstring = {
    enable = true
  }
}
EOF
" }}}


nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


" Set the ilver searcher for the Ack command
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Telescope fzf native (it makes telescope much faster)
"-- You dont need to set any of these options. These are the default ones. Only
lua <<EOF
-- the loading is important
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
EOF
