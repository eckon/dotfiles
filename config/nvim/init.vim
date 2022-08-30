" -------------------- Plugin Installations
call plug#begin()
  " General Tools
  Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-surround'

  " Fuzzy-Finder/Tree-View/Navigation
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } | Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'phaazon/hop.nvim'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
  Plug 'j-hui/fidget.nvim'

  " Debugger
  Plug 'mfussenegger/nvim-dap'
  Plug 'theHamsta/nvim-dap-virtual-text'

  " Syntax/Styling/Appearance/Special
  Plug 'ellisonleao/gruvbox.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()



" -------------------- General Configuration
let mapleader = "\<Space>"

set clipboard+=unnamedplus shell=bash undofile noswapfile title
set completeopt=menuone,noinsert,noselect
set magic lazyredraw ignorecase smartcase
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smartindent expandtab
set shortmess+=c noshowmode
set signcolumn=yes
set splitbelow splitright
set updatetime=100
set wildmode=list:longest,list:full



" -------------------- Color/Style Configuration
colorscheme gruvbox

set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,lead:\ ,trail:·,space:\ ,tab:▸\ 
set scrolloff=5 sidescrolloff=5 nowrap
set termguicolors
set winbar=%t\ %m

set foldlevelstart=99 fillchars=fold:\ 
set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))



" -------------------- Autocommands
augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
augroup END

augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
    \ if &ft !~# 'commit\|rebase' && line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END

augroup ResourceConfigOnSave
  autocmd!
  execute "autocmd BufWritePost " . expand("$MYVIMRC") . " source <sfile>"
augroup END



" -------------------- General Key Bindings / Commands
" ---------- Custom Key Bindings
" disable annoying keys
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
noremap U <Nop>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" append jump-commands for quickfix-list jumps
nnoremap [q <CMD>cprevious<CR>zz
nnoremap ]q <CMD>cnext<CR>zz
nnoremap [Q <CMD>cfirst<CR>zz
nnoremap ]Q <CMD>clast<CR>zz

" quickly update macro - use wanted register - press enter to execute
nnoremap <Leader>m :<C-u><C-r><C-r>='let @' . v:register . ' = ' . string(getreg(v:register))<CR><C-f><LEFT>

" custom textobject for indentations
onoremap <silent> ii :lua require('textobjects').indent_inner_textobject()<CR>
xnoremap <silent> ii :<C-u>lua require('textobjects').indent_inner_textobject()<CR>
onoremap <silent> ai :lua require('textobjects').indent_around_textobject()<CR>
xnoremap <silent> ai :<C-u>lua require('textobjects').indent_around_textobject()<CR>



" ---------- Custom Commands
" quickly setup vim for pair programming
command! CCPairProgramming tabdo windo set norelativenumber

" open current buffer file in the browser (needs to be cloned over git with ssh)
command! CCBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/$(
  \   git config --get remote.origin.url | grep -q 'bitbucket.org'
  \     && echo 'src/master'
  \     || echo blob/$(git branch --show-current)
  \ )/%

" open current project and goto the current buffer file in vscode
command! CCVSCode !code $(pwd) -g %



" -------------------- Plugin Configurations
" ---------- Language Server Protocol (LSP)
" ----- Configurations
lua << EOL
require('fidget').setup({})

require('lsp_lines').setup()
vim.diagnostic.config({ virtual_text = false })

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'html', 'vimls', 'sumneko_lua', 'jsonls', 'yamlls',
    'cssls', 'emmet_ls', 'taplo',
    'pyright', 'tsserver', 'volar', 'rust_analyzer',
  },
})

local null_ls = require('null-ls')
null_ls.setup({ sources = {
  null_ls.builtins.formatting.prettierd,
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.code_actions.eslint_d,
  null_ls.builtins.formatting.black,
}})

local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function (server_name)
    lspconfig[server_name].setup({
      capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      ),
    })
  end,
  ['sumneko_lua'] = function ()
    lspconfig.sumneko_lua.setup({
      settings = { Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      }},
    })
  end,
})

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})
EOL


" ----- Mappings
nnoremap <silent>K :call <SID>show_documentation()<CR>
inoremap <C-k> <CMD>lua vim.lsp.buf.signature_help()<CR>

nnoremap gd <CMD>lua require('telescope.builtin').lsp_definitions({ show_line = false })<CR>
nnoremap gD <CMD>lua require('telescope.builtin').lsp_type_definitions({ show_line = false })<CR>
nnoremap gr <CMD>lua require('telescope.builtin').lsp_references({ show_line = false })<CR>
nnoremap [d <CMD>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d <CMD>lua vim.diagnostic.goto_next()<CR>

nnoremap <Leader>la <CMD>lua vim.lsp.buf.code_action()<CR>
nnoremap <Leader>lr <CMD>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>lf <CMD>lua vim.lsp.buf.format({ async = true })<CR>
nnoremap <Leader>ld <CMD>lua vim.diagnostic.open_float()<CR>
nnoremap <Leader>lh <CMD>lua require('lsp_lines').toggle()<CR>
nnoremap <Leader>ll <CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>

function! s:show_documentation() abort
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'help ' . expand('<cword>')
  else
    execute 'lua vim.lsp.buf.hover()'
  endif
endfunction



" ---------- Debugger
" ----- Configurations
lua << EOL
local dap = require('dap')
require('nvim-dap-virtual-text').setup()

dap.listeners.after['event_initialized']["repl_config"] = function() dap.repl.open()  end
dap.listeners.before['event_exited']["repl_config"]     = function() dap.repl.close() end
dap.listeners.before['event_terminated']["repl_config"] = function() dap.repl.close() end

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

dap.configurations.typescript = {{ name = 'Attach to process', type = 'node2', request = 'attach' }}
EOL


" ----- Mappings
nnoremap <silent> <Leader>db <CMD>lua require('dap').toggle_breakpoint()<CR>
nnoremap <silent> <Leader>dB <CMD>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>dE <CMD>lua require('dap').set_exception_breakpoints({ 'all' })<CR>
nnoremap <silent> <Leader>dK <CMD>lua require('dap.ui.widgets').hover()<CR>

nnoremap <silent> <Leader>dd <CMD>lua require('dap').continue()<CR>
nnoremap <silent> <Leader>dD <CMD>lua require('dap').terminate(); require('dap').terminate()<CR>

nnoremap <silent> <Leader>dh <CMD>lua require('dap').step_into()<CR>
nnoremap <silent> <Leader>dj <CMD>lua require('dap').step_over()<CR>
nnoremap <silent> <Leader>dl <CMD>lua require('dap').step_out()<CR>
nnoremap <silent> <Leader>dc <CMD>lua require('dap').run_to_cursor()<CR>



" ---------- Treesitter
" ----- Configurations
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
    -- regex highlight is still better than Treesitter highlight
    disable = { 'php', 'vim' },
  },
  context_commentstring = { enable = true },
})
EOF



" ---------- Fuzzy-Finder
" ----- Configurations
lua << EOF
local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    color_devicons = true,
    layout_strategy = 'vertical',
    path_display = { 'truncate' },
    mappings = {
      i = {
        ['<C-j>'] = actions.cycle_history_next,
        ['<C-k>'] = actions.cycle_history_prev,
        ['<C-f>'] = actions.to_fuzzy_refine,
      },
    },
  },
})

require('telescope').load_extension('fzf')
EOF


" ----- Mappings
nnoremap <Leader>fa <CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input({ prompt = 'Grep > ' }) })<CR>
nnoremap <Leader>fA <CMD>lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>fr <CMD>lua require('telescope.builtin').resume()<CR>

nnoremap <Leader>fb <CMD>lua require('telescope.builtin').buffers({ sort_mru = true })<CR>
nnoremap <Leader>ff <CMD>lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>fg <CMD>lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>fl <CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
nnoremap <Leader>fs <CMD>lua require('telescope.builtin').spell_suggest()<CR>



" ---------- Git
" ----- Configurations
lua << EOF
require('gitsigns').setup({ keymaps = {} })
EOF


" ----- Mappings
nnoremap <Leader>gb <CMD>lua require('gitsigns').blame_line({ full = true })<CR>
nnoremap <Leader>gq <CMD>lua require('gitsigns').setqflist('all')<CR>

nnoremap ]c <CMD>Gitsigns next_hunk<CR>zz
nnoremap [c <CMD>Gitsigns prev_hunk<CR>zz



" ---------- Statusline
" ----- Configurations
lua << EOF
require('lualine').setup({
  options = {
    component_separators = {},
    globalstatus = true,
    section_separators = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
EOF



" ---------- Filetree
" ----- Configurations
lua << EOF
require('nvim-tree').setup({
  actions = { open_file = { quit_on_open = true } },
  git = { ignore = false },
  renderer = {
    add_trailing = true,
    group_empty = true,
  },
  view = {
    adaptive_size = true,
    hide_root_folder = true,
    relativenumber = true,
  },
})
EOF


" ----- Mappings
nnoremap <Leader>. <CMD>NvimTreeFindFileToggle<CR>



" ---------- hop
" ----- Configurations
lua << EOF
require('hop').setup()
EOF


" ----- Mappings
noremap H <CMD>HopChar1<CR>



" ---------- neorg
" ----- Configurations
lua << EOF
require('neorg').setup({
  load = {
    ['core.defaults'] = {},
    ['core.norg.concealer'] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          private = '~/Documents/notes/private',
          work = '~/Documents/notes/work',
        },
        autochdir = true,
        index = '_refill.norg',
      },
    },
  },
})
EOF
