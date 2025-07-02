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
vim.opt.mouse          = 'nv'
vim.wo.signcolumn      = 'yes'
vim.wo.number          = true
vim.wo.relativenumber  = true
vim.opt.completeopt    = 'menuone,noselect'
vim.o.clipboard        = 'unnamedplus'
vim.o.mousescroll      = 'ver:2,hor:0'
-- vim.opt.statusline     = '%<%F %h%m%r%=%l,%c%V  %P'

-- render whitespace characters
vim.o.list             = true
vim.o.listchars        = 'space:·,tab:-> ,lead:•,trail:•'

-- render trailing whitespace characters (https://www.manjotbal.ca/blog/neovim-whitespace.html)
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='LightRed' })
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  command = [[
    syntax clear TrailingWhitespace |
    syntax match TrailingWhitespace "\_s\+$"
  ]]}
)

-- local project configs
vim.o.exrc = true
vim.o.secure = true

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
   -- Break bad habits, master Vim motions
   "m4xshen/hardtime.nvim",
   lazy = false,
   dependencies = { "MunifTanjim/nui.nvim" },
   opts = {
      disable_mouse = false,
      disabled_keys = {
       ["<Up>"] = false, -- Allow <Up> key
       ["<Down>"] = false,
       ["<Left>"] = false,
       ["<Right>"] = false,
    },
    },
  },
  {
    -- Neovim's answer to the mouse
    "ggandor/leap.nvim",
    lazy = false,
    dependencies = {},
    opts = {},
    config = function()
      vim.keymap.set({'n', 'x', 'o'}, 't', '<Plug>(leap)')
      vim.keymap.set('n',             'T', '<Plug>(leap-from-window)')
    end,
  },
  {
    -- Advanced notification system.
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<C-c>', 'copilot#Accept("<CR>")', { expr = true, silent = true, replace_keycodes = false })
      vim.keymap.set('i', '<C-e>', 'copilot#Dismiss()', { expr = true, silent = true, replace_keycodes = false })
    end
  },
  {
    -- Chat with GitHub Copilot in Neovim.
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
  },
  {
    -- A snazzy bufferline for Neovim.
    'akinsho/bufferline.nvim', 
    version = "*", 
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    keys = {
      -- { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      -- { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      -- { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      -- { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      -- { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      -- { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      -- { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      -- { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      -- { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      -- { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        -- diagnostics_indicator = function(_, _, diag)
        --   local icons = LazyVim.config.icons.diagnostics
        --   local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        --     .. (diag.warning and icons.Warn .. diag.warning or "")
        --   return vim.trim(ret)
        -- end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        -- get_element_icon = function(opts)
        --   return LazyVim.config.icons.ft[opts.filetype]
        -- end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  -- {
  --   -- A color scheme for Sublime Text, (Neo)Vim, iTerm, and more. Based on Atom's One.
  --   -- 'sonph/onehalf',
  --   -- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme. Includes extra themes for Kitty, Alacritty, iTerm and Fish.
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     -- vim.opt.rtp:append(plugin.dir .. "/vim")
  --     vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
  -- {
  --  -- Neovim file explorer: edit your filesystem like a buffer
  --  'stevearc/oil.nvim',
  --  config = function()
  --    require("oil").setup({
  --      keymaps = {
  --        ["q"] = "actions.close"
  --      },
  --      view_options = {
  --        -- Show files and directories that start with "."
  --        show_hidden = true,
  --        is_always_hidden = function(name, bufnr)
  --          return name == ".."
  --        end,
  --      },
  --    })
  --    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  --  end,
  -- },
  {
    -- A highly customizable theme for vim and neovim with support for lsp, treesitter and a variety of plugins. 
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
    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing. 
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
  },
  { 
    -- Twilight is a Lua plugin for Neovim 0.5 that dims inactive portions of the code you're editing using TreeSitter.
    'folke/twilight.nvim',
    config = function()
      require("twilight").setup {}
    end,
  },
  { 
    -- Create key bindings that stick. WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type. 
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
    -- A completion plugin for neovim coded in Lua. 
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      local cmp = require 'cmp'

      cmp.setup({
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
             local col = vim.fn.col('.') - 1

             if cmp.visible() then
               cmp.select_next_item()
             elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
               fallback()
             else
               cmp.complete()
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
          { name = 'conjure' },
          { name = 'buffer' },
          -- { name = 'luasnip' },
          { name = 'path' },
          { name = 'cmdline' },
        }),
        completion = {
          autocomplete = false
        },
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
        autoformat = true,
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
      require("nvim-treesitter.configs").setup {
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
          "just"
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
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require("nvim-tree").setup({
        filters = {
          git_ignored = false,
        },
      })
    end,
  },
  {
    -- Vim script for text filtering and alignment.
    'godlygeek/tabular'
  },
  {
    -- IDE-like breadcrumbs, out of the box.
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },
  {
    -- Bookmark your files, separated by project, and quickly navigate through them.
    "otavioschwanck/arrow.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      -- or if using `mini.icons`
      -- { "echasnovski/mini.icons" },
    },
    opts = {
      show_icons = true,
      leader_key = ';', -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
    }
  }
})

vim.cmd([[
  nnoremap <silent> <C-e> :NvimTreeFindFileToggle<CR>
  nnoremap <silent> <C-p> :Telescope<CR>

  nnoremap <silent> zx :bp<BAR>bd#<CR>
  nnoremap <silent> gq :bd<CR>
  nnoremap <silent> <leader>w :w<CR>
  nnoremap <silent> <leader><Tab> <C-^>
  nnoremap <silent> Y y$
  nnoremap <silent> <leader>y "+yiw
  vnoremap <silent> <leader>y "+y

  map Q gq

  " :W is the same as :w
  command! W w

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
