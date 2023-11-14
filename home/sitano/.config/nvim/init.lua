vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.cmd([[
augroup vimrcEx
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

filetype on
syntax on
runtime! ftplugin/man.vim
]])

vim.g.netrw_browse_split = 0
vim.g.netrw_banner       = 0
vim.g.netrw_winsize      = 25

vim.opt.guifont = "Comic Mono:h24"
vim.opt.termguicolors = true
vim.opt.scrolloff     = 8
vim.opt.updatetime    = 250
vim.opt.timeoutlen    = 300

vim.opt.tabstop     = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
vim.opt.expandtab   = true
vim.opt.list        = true

vim.opt.si             = true
vim.opt.breakindent    = true
vim.opt.backup         = false
vim.opt.swapfile       = false
vim.opt.undofile       = true
vim.opt.undodir        = os.getenv("HOME") .. "/.vim/undo"
vim.opt.confirm        = true
vim.opt.ignorecase     = true
vim.opt.hlsearch       = true
vim.opt.wrap           = false
vim.opt.smartcase      = true
vim.opt.tags           = "./tags,tags,../tags,../../tags"
vim.opt.wildignorecase = true
vim.wo.signcolumn      = 'yes'
vim.wo.number          = true
vim.opt.completeopt    = 'menuone,noselect'
vim.o.clipboard        = 'unnamedplus'
vim.o.mousescroll      = 'ver:2,hor:0'
vim.o.list             = true

require("lazy").setup({
  -- {
  --   -- 'sonph/onehalf',
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     -- vim.opt.rtp:append(plugin.dir .. "/vim")
  --     vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
  -- 'MunifTanjim/nui.nvim',
  {
    'EdenEast/nightfox.nvim', -- 'rose-pine/neovim', -- 'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light"
      vim.cmd.colorscheme "nightfox"
    end,
  },
  {
    'andymass/vim-matchup',
    config = function()
      vim.cmd([[
        let g:matchup_matchparen_deferred = 1
        let g:matchup_matchparen_hi_surround_always = 1
      ]])
    end,
  },
  -- 'cohama/lexima.vim',
  {
    'windwp/nvim-autopairs',
     event = "InsertEnter",
     opts = {}
  },

  'folke/lsp-colors.nvim',
  { 
    'folke/trouble.nvim',
    config = function()
      require("trouble").setup {
        icons = true,
        auto_preview = false,
      }
      vim.cmd([[
        nnoremap <silent> <leader>xx <cmd>TroubleToggle quickfix<cr>
      ]])
    end,
  },
  { 
    'folke/twilight.nvim',
    config = function()
      require("twilight").setup {}
    end,
  },
  { 
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup {}
    end,
  },
  {
    'folke/zen-mode.nvim',
    config = function()
      require("zen-mode").setup {
        plugins = {
          twilight = { enabled = true },
        }
      }

      vim.cmd([[
        nnoremap <silent> <leader><cr> <cmd>ZenMode<cr>
      ]])
    end
  },
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- 'hrsh7th/cmp-vsnip',
      -- 'hrsh7th/vim-vsnip',
      -- 'hrsh7th/vim-vsnip-integ',
      'PaterJason/cmp-conjure',
      'rafamadriz/friendly-snippets',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      local cmp = require'cmp'

      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
              select = true,
              behavior = cmp.ConfirmBehavior.Replace,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        
          ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                  cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
              else
                  fallback()
              end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function()
              if cmp.visible() then
                  cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
              else
                  fallback()
              end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'conjure' },
        }),
        completion = {
          autocomplete = false,
        }
      })
    end,
  },
  {
    'jremmen/vim-ripgrep',
    config = function()
      vim.cmd([[
        nnoremap <leader>/ :Rg<Space><c-r><c-w>
        vnoremap <leader>/ y :Rg<Space><c-r>"
      ]])
    end,
  },
  {
    'junegunn/gv.vim',
    config = function()
      vim.cmd([[
        nnoremap <silent> <leader>gd :Gvdiff<CR>
      ]])
    end
  },
  {
    'junegunn/vim-easy-align',
    config = function()
    vim.cmd([[
      " Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap ga <Plug>(EasyAlign)
      " Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap ga <Plug>(EasyAlign)
    ]])
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup{
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('neodev').setup()

      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', function()
          vim.cmd("TroubleToggle document_diagnostics")
      end, opts)
      vim.keymap.set('n', '<space>E', function()
          vim.cmd("TroubleToggle workspace_diagnostics")
      end, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      local on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', function()
          vim.cmd("Trouble lsp_references")
        end, bufopts)
      end

      local caps = vim.lsp.protocol.make_client_capabilities()
      caps = require('cmp_nvim_lsp').default_capabilities(caps)

      local nvim_lsp = require('lspconfig')
      flags = {
        debounce_text_changes = 500,
      }
      nvim_lsp.gopls.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = true,
        capabilities = caps,
      }
      nvim_lsp.ruby_ls.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.rust_analyzer.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = true,
        capabilities = caps,
      }
      nvim_lsp.zls.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.hls.setup {
        cmd = { 'haskell-language-server-wrapper', '--lsp' },
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.clojure_lsp.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.clangd.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.yamlls.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }

      -- local on_references = vim.lsp.handlers["textDocument/references"]
      -- vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
      --   on_references, {
      --     -- Use location list instead of quickfix list
      --     loclist = true,
      --   }
      -- )
      -- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    end,
    dependencies = {
      'folke/neodev.nvim',
    }
  },
  'nvim-lua/popup.nvim',
  { 
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = "make",
      },
      -- 'nvim-telescope/telescope-file-browser.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          layout_strategy = 'center',
          layout_config = { height = 0.5, width = 0.8 },
        },
        pickers = {
          find_files = {
            previewer = false,
          },
          oldfiles = {
            previewer = false,
          },
          buffers = {
            previewer = false,
          },
          file_browser = {
            previewer = false,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          -- file_browser = {
          --   respect_gitignore = false,
          --   hidden = true
          -- }
        }
      }
      -- telescope.load_extension("file_browser")
      telescope.load_extension("fzf")

      vim.cmd([[
        " nnoremap <silent> - :Telescope file_browser path=%:p:h hidden=true<cr>

        " nnoremap <silent> <leader><leader> <cmd>Telescope command_history<cr>
        nnoremap <silent> <leader>f <cmd>Telescope find_files<cr>
        nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
        nnoremap <silent> <leader>s <cmd>Telescope lsp_document_symbols<cr>
        nnoremap <silent> <leader>r <cmd>Telescope oldfiles<cr>
      ]])
    end,
  },
  {
    'nvim-tree/nvim-web-devicons', lazy = true,
    config = function()
      require'nvim-web-devicons'.setup {
       -- globally enable default icons (default to false)
       -- will get overriden by `get_icons` option
       default = true;
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { 
          "vimdoc",
          "javascript",
          "typescript",
          "c",
          "cpp",
          "lua",
          "rust",
          "go",
          "json",
          "yaml",
          "zig",
          "clojure",
        },

        -- If TS highlights are not enabled at all, or disabled via `disable` prop,
        -- highlighting will fallback to default Vim syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<leader><space>',
                node_incremental = '<leader><space>',
                node_decremental = '<c-space>',
            },
        },
        matchup = {
          enable = true,
        }
      }
    end,
    build = ":TSUpdate",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
    }
  },
  'radenling/vim-dispatch-neovim',
  'rust-lang/rust.vim',
  'sindrets/diffview.nvim',
  -- 'tpope/vim-abolish',
  'tpope/vim-bundler',
  'tpope/vim-commentary',
  'tpope/vim-dispatch',
  'tpope/vim-endwise',
  'tpope/vim-sleuth',
  'tpope/vim-vinegar',
  {
    'tpope/vim-fugitive',
    config = function()
      vim.cmd([[
        nnoremap <silent> <leader>gg :Git<CR>
        nnoremap <silent> <leader>gb :Git blame<CR>
        nnoremap <leader>gP :Git pull -r<Space>
        nnoremap <leader>gp :Git push origin<Space>
        nnoremap <leader>gc :Git checkout<Space>
        nnoremap <leader>gs :Git switch<Space>
      ]])
    end
  },
  'tpope/vim-obsession',
  'tpope/vim-projectionist',
  'tpope/vim-rails',
  'tpope/vim-rake',
  'tpope/vim-surround',
  'vim-ruby/vim-ruby',
  {
    'w0rp/ale',
    config = function()
    vim.cmd([[
                  " \ 'go': ['govet', 'gobuild'],
                  " \ 'rust': ['cargo', 'rust-analyzer'],
      let g:ale_linters = {
                  \ 'python': ['pylint', 'autopep8'],
                  \ 'sh': ['shellcheck'],
                  \ 'ruby': ['rubocop', 'sorbet'],
                  \ 'cpp': ['clangd'],
                  \ }
      let g:ale_ruby_rubocop_executable = 'bundle exec rubocop'
      let g:ale_ruby_sorbet_executable = 'bundle exec srb'
      let g:ale_linters_explicit = 1
      let g:ale_lint_on_text_changed = 'never'
      let g:ale_set_quickfix = 1
      let g:ale_lint_on_enter = 0
      let g:ale_lint_on_save = 1
      let g:ale_disable_lsp = 1

      let g:ale_go_golangci_lint_options = ''
      let g:ale_go_golangci_lint_package = 1
      
      let g:ale_fixers = {
                  \ 'go': ['goimports'],
                  \ 'rust': ['rustfmt'],
                  \ 'cpp': ['clang-format'],
                  \ }
      let g:ale_fix_on_save = 1
      let g:ale_rust_cargo_use_clippy = 1
      let g:ale_set_quickfix = 1
    ]])
    end,
  },
  'ziglang/zig.vim',
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("ibl").setup {
        indent = { char = "┊" },
        whitespace = {
            remove_blankline_trail = false,
        },
        scope = { enabled = false },
        -- char = '┊',
        -- show_trailing_blankline_indent = false,
        -- space_char_blankline = ' ',
        -- show_current_context = true,
        -- show_current_context_start = true,
      }
    end,
  },
  'Olical/conjure',
  {
    'nvim-tree/nvim-tree.lua',
    config = true
  }
})

vim.cmd([[
  nnoremap <silent> <C-e> :NvimTreeOpen<CR>
  nnoremap <silent> <C-p> :Telescope<CR>

  nnoremap <silent> zx :bp<BAR>bd#<CR>
  nnoremap <silent> gq :bd<CR>
  nnoremap <silent> zz :w<CR>
  nnoremap <silent> <leader><Tab> <C-^>
  nnoremap <silent> Y y$
  nnoremap <silent> <leader>y "+yiw
  vnoremap <silent> <leader>y "+y

  " nnoremap <silent> <Left> :tabp<CR>
  " nnoremap <silent> <Right> :tabn<CR>
  " nnoremap <silent> <Up> <nop>
  " nnoremap <silent> <Down> <nop>

  map Q gq

  inoremap jk <esc>
  tnoremap <c-space> <c-\><c-n>

  nnoremap <silent> <leader>1 1gt
  nnoremap <silent> <leader>2 2gt
  nnoremap <silent> <leader>3 3gt
  nnoremap <silent> <leader>4 4gt
  nnoremap <silent> <leader>5 5gt
  nnoremap <silent> <leader>6 6gt
  nnoremap <silent> <leader>7 7gt
  nnoremap <silent> <leader>8 8gt
  nnoremap <silent> <leader>9 9gt
  nnoremap <silent> <leader>0 0gt

  cnoremap <C-p> <Up>
  cnoremap <C-n> <Down>
  cnoremap <C-f> <Right>
  cnoremap <C-b> <Left>

  cnoremap <M-f> <C-Right>
  cnoremap <M-b> <C-Left>
]])
