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

vim.opt.termguicolors = true
vim.opt.scrolloff     = 8
vim.opt.updatetime    = 250
vim.opt.timeoutlen    = 300

vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true

vim.opt.si             = true
vim.opt.breakindent    = true
vim.opt.backup         = false
vim.opt.swapfile       = false
vim.opt.undofile       = true
vim.opt.undodir        = os.getenv("HOME") .. "/.vim/undo"
vim.opt.confirm        = true
vim.opt.ignorecase     = true
vim.opt.hlsearch       = true
vim.opt.wrap           = true
vim.opt.smartcase      = true
vim.opt.tags           = "./tags,tags,../tags,../../tags"
vim.opt.wildignorecase = true
vim.opt.mouse          = 'nv'
vim.wo.signcolumn      = 'yes'
vim.opt.completeopt    = 'menuone,noselect,noinsert'
vim.o.clipboard        = 'unnamedplus'
vim.o.mousescroll      = 'ver:2,hor:0'
vim.opt.statusline     = '%<%F %h%m%r%=%l,%c%V  %P'

function lsp_buf_bindings(client, bufnr)
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
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gh', vim.diagnostic.open_float, bufopts)
end

require("lazy").setup({
  {
    'stevearc/oil.nvim',
    config = function()
      require("oil").setup({
        keymaps = {
          ["q"] = "actions.close"
        },
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
          is_always_hidden = function(name, bufnr)
            return name == ".."
          end,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
  {
    -- 'folke/tokyonight.nvim',
    -- "miikanissi/modus-themes.nvim",
    -- 'rose-pine/neovim',
    -- 'catppuccin/nvim', 
    -- 'ellisonleao/gruvbox.nvim',
    -- 'EdenEast/nightfox.nvim', 
    -- 'catppuccin/nvim',
    -- 'p00f/alabaster.nvim',
    "savq/melange-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light"
      vim.cmd.colorscheme "melange"
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
  {
    'windwp/nvim-autopairs',
     event = "InsertEnter",
     opts = {}
  },
  'folke/lsp-colors.nvim',
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      {
        "<leader>t",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
    }
  },
  { 
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup {}
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      zen = { enabled = true },
      bufdelete = { enabled = true },
      -- words = { enabled = true },
    },
    keys = {
      { "gq", function() Snacks.bufdelete() end, desc = "Delete current buffer" },
      { "zx", function() Snacks.bufdelete() end, desc = "Delete current buffer" },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- 'PaterJason/cmp-conjure',
    },
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
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
          ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'conjure' },
          { name = 'orgmode' },
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
  -- {
  --   'junegunn/gv.vim',
  --   config = function()
  --     vim.cmd([[
  --       nnoremap <silent> <leader>gd :Gvdiff<CR>
  --     ]])
  --   end
  -- },
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

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local on_attach = lsp_buf_bindings
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
      nvim_lsp.ruby_lsp.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.rust_analyzer.setup {
        settings = {
          ['rust-analyzer'] = {
            check = {command = "clipppy"}
          },
        },
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
      nvim_lsp.ocamllsp.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
      }
      nvim_lsp.elixirls.setup {
        on_attach = on_attach,
        flags = flags,
        autostart = false,
        capabilities = caps,
        cmd = { "/usr/local/bin/elixir-ls" }
      }
    end
  },
  'nvim-lua/popup.nvim',
  { 
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = "make",
      },
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          layout_strategy  = 'bottom_pane',
          layout_config    = { prompt_position = "top" },
          sorting_strategy = "ascending",
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
            respect_gitignore = true,
            hidden = { file },
            grouped = true,
          },
          fd = {
            previewer = false,
            hidden = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = false,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
          }
        }
      }
      telescope.load_extension("file_browser")
      telescope.load_extension("fzf")

      vim.cmd([[
        " nnoremap <silent> - :Telescope file_browser path=%:p:h hidden=true<cr>

        " nnoremap <silent> <leader><leader> <cmd>Telescope command_history<cr>
        nnoremap <silent> <leader>f <cmd>Telescope fd<cr>
        nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
        nnoremap <silent> <leader><leader> <cmd>Telescope builtin<cr>
        nnoremap <silent> <leader>' <cmd>Telescope lsp_document_symbols<cr>
        nnoremap <silent> <leader>r <cmd>Telescope oldfiles<cr>
        nnoremap <silent> <leader>h <cmd>Telescope help_tags<cr>
      ]])
    end,
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = lsp_buf_bindings

      local caps = vim.lsp.protocol.make_client_capabilities()
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(caps)
      metals_config.init_options.statusBarProvider = "on"
      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
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
    'nvim-orgmode/orgmode',
    config = function()
      local org = require('orgmode')
      -- org.setup_ts_grammar()
      org.setup({
        org_agenda_files = '~/org/*.org',
        org_default_notes_file = '~/org/journal.org',
        org_todo_keywords = {'TODO', 'REVIEW', '|', 'DONE', 'DELEGATED'},
        org_todo_keyword_faces = {
          REVIEW = ':foreground blue :weight bold',
          DELEGATED = ':background #FFFFFF :slant italic :underline on',
        }
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { 
          "c",
          "clojure",
          "cpp",
          "diff",
          "go",
          "haskell",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "ocaml",
          "org",
          "ruby",
          "rust",
          "scala",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
          "zig",
          "sql",
          "elixir",
          "typst",
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
            init_selection   = '<leader>m',
            node_incremental = 'm',
            node_decremental = 'M',
          },
        },
        matchup = {
          enable = true,
        }
      }
    end,
    build = ":TSUpdate",
  },
  'radenling/vim-dispatch-neovim',
  'rust-lang/rust.vim',
  'sindrets/diffview.nvim',
  'tpope/vim-bundler',
  'tpope/vim-commentary',
  'tpope/vim-dispatch',
  'tpope/vim-endwise',
  'tpope/vim-sleuth',
  {
    'tpope/vim-fugitive',
    config = function()
      vim.cmd([[
        nnoremap <silent> <leader>gb :Git blame<CR>
        nnoremap <silent> <leader>gg :Git<CR>
        nnoremap <leader>gP :Git pull -r<Space>
        nnoremap <leader>gp :Git push -v origin<Space>
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
      let g:ale_linters = {
                  \ 'python': ['pylint', 'autopep8'],
                  \ 'sh': ['shellcheck'],
                  \ 'ruby': ['rubocop', 'sorbet'],
                  \ 'cpp': ['clangd'],
                  \ 'proto': ['protoc-gen-lint', 'protolint'],
                  \ 'rust': ['cargo', 'rust-analyzer'],
                  \ }
      "let g:ale_ruby_rubocop_executable = 'bundle exec rubocop'
      "let g:ale_ruby_sorbet_executable = 'bundle exec srb'
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
    "Olical/conjure",
    ft = { "clojure" }, -- etc
    lazy = true,

    -- Optional cmp-conjure integration
    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    lazy = true,
  },
})

vim.cmd([[
  " nnoremap <silent> zx :bd<CR>
  nnoremap <silent> gi :e ~/.config/nvim/init.lua<CR>
  " nnoremap <silent> gq :bd<CR>
  nnoremap <silent> zz :w<CR>
  nnoremap <silent> <Tab> <C-^>
  nnoremap <silent> Y y$
  nnoremap <silent> <leader>y "+yiw
  vnoremap <silent> <leader>y "+y

  nnoremap <silent> <Left> :tabp<CR>
  nnoremap <silent> <Right> :tabn<CR>
  nnoremap <silent> <Up> <nop>
  nnoremap <silent> <Down> <nop>

  nnoremap <silent> k gk
  nnoremap <silent> j gj
  vnoremap <silent> k gk
  vnoremap <silent> j gj

  map Q gq

  inoremap <silent> <c-g> <esc>
  nnoremap <silent> <c-g> <esc>
  vnoremap <silent> <c-g> <esc>
  inoremap <silent> jk <esc>
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
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>

  cnoremap <M-f> <C-Right>
  cnoremap <M-b> <C-Left>
]])
