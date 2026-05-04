local opt = vim.opt

-- Search Settings
opt.smartcase = true -- Smart case sensitivity in search
opt.ignorecase = true -- Case insensitive search by default
opt.inccommand = "split" -- Show incremental substitution results in preview split
opt.hlsearch = true
opt.incsearch = true

opt.textwidth = 0

-- Display Settings
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.cursorcolumn = true -- Highlight current column
opt.colorcolumn = "80,120"
opt.signcolumn = "yes" -- Always show sign column
opt.scrolloff = 8 -- Lines to keep above/below cursor
opt.smoothscroll = true
opt.ruler = true -- Show cursor position
opt.wildmenu = true
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.more = false -- Disable 'more' prompt for long messages

opt.completeopt = { "menu", "menuone", "noselect" }
opt.backspace = { "indent", "eol", "start" }
opt.termguicolors = true

opt.laststatus = 2

-- Editor Settings
opt.mouse = "a" -- Enable mouse support
opt.wrap = true -- Wrap long lines
opt.linebreak = true -- Wrap at word boundaries
opt.list = true -- Don't show invisible characters by default
opt.listchars = { -- Characters to show when list is enabled
  tab = ">-",
  eol = "¬",
  lead = "·",
  trail = "-",
}

-- Indentation Settings
opt.tabstop = 2 -- Tab width
opt.softtabstop = 2 -- Soft tab width
opt.shiftwidth = 2 -- Indent width
opt.expandtab = true -- Use spaces instead of tabs
opt.backspace = { "indent", "start", "eol" } -- Backspace behavior

-- Split Settings
opt.splitbelow = true -- New horizontal splits below
opt.splitright = true -- New vertical splits to the right

-- File Settings
opt.swapfile = false -- Don't create swap files
opt.shada = { "'10", "<0", "s10", "h" } -- Shared data configuration

-- Formatting Settings
opt.formatoptions:remove("o") -- Don't continue comments with 'o'

-- Font Support
vim.g.have_nerd_font = true

opt.termguicolors = true

vim.filetype.add({
  extension = {
    conf = "bash", -- or 'sh', 'conf', etc.
  },
  pattern = {
    -- Use regex for specific file patterns
    ["*.env"] = "env",
    [".env.*"] = "env",
    ["*.dockerfile"] = "dockerfile",
    ["Dockerfile.*"] = "dockerfile",
  },
})

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = true,

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
})

require("autocmd")
require("usercmd")
require("keymaps")
require("terminal")

vim.g.VM_leader = ","
vim.g.format_on_save = 0
vim.g.tmux_navigator_no_mappings = 1
vim.o.background = "dark"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "nvim-lua/plenary.nvim", dev = false },
    { "tpope/vim-repeat" }, -- Repeat actions better
    { "tpope/vim-abolish" }, -- Cool things with words!
    { "matze/vim-move" }, -- Move lines and blocks
    { "OXY2DEV/helpview.nvim", lazy = false },

    {
      "rcarriga/nvim-notify",
      config = function()
        local notify = require("notify")
        notify.setup({ render = "compact", stages = "static" })
        vim.notify = notify
      end,
    },
    -- ICONS
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "echasnovski/mini.icons", opts = {} },

    -- Colorschemes
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        variant = "night",
      },
    },
    { "tjdevries/colorbuddy.nvim" },
    { "tjdevries/gruvbuddy.nvim" },
    { dir = "~/git/min-theme.nvim" },
    {
      "navarasu/onedark.nvim",
      opts = {
        highlights = {
          ["@constructor"] = { fg = "$light_grey", fmt = "bold" },
        },
        diagnostics = { darker = false },
      },
    },

    -- Comment
    {
      "numToStr/Comment.nvim",
      opts = {
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
        },
        pre_hook = nil, ---Function to call after (un)comment
        post_hook = nil,
      },
      config = function()
        local comment_ft = require("Comment.ft")
        comment_ft.set("lua", { "--%s", "--[[%s]]" })
        comment_ft.set("env", { "#%s", "#%s" })
        comment_ft.set("conf", { "#%s", "#%s" })
      end,
    },

    -- Surround
    {
      "echasnovski/mini.surround",
      config = function()
        require("mini.surround").setup()
      end,
      keys = function(_, keys)
        -- Populate the keys based on the user's options
        local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
        local opts = require("lazy.core.plugin").values(plugin, "opts", false)
        local mappings = {
          {
            opts.mappings.add,
            desc = "Add surrounding",
            mode = { "n", "v" },
          },
          { opts.mappings.delete, desc = "Delete surrounding" },
          { opts.mappings.find, desc = "Find right surrounding" },
          { opts.mappings.find_left, desc = "Find left surrounding" },
          { opts.mappings.highlight, desc = "Highlight surrounding" },
          { opts.mappings.replace, desc = "Replace surrounding" },
          {
            opts.mappings.update_n_lines,
            desc = "Update `MiniSurround.config.n_lines`",
          },
        }
        mappings = vim.tbl_filter(function(m)
          return m[1] and #m[1] > 0
        end, mappings)
        return vim.list_extend(mappings, keys)
      end,
      opts = {
        mappings = {
          add = "sa", -- Add surrounding in Normal and Visual modes
          delete = "sd", -- Delete surrounding
          find = "sf", -- Find surrounding (to the right)
          find_left = "sF", -- Find surrounding (to the left)
          highlight = "sh", -- Highlight surrounding
          replace = "sr", -- Replace surrounding
          update_n_lines = "sn", -- Update `n_lines`
        },
      },
    },

    -- Git

    {
      "lewis6991/gitsigns.nvim",
      opts = {
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]h", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Jump to next git change" })

          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[h", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Jump to previous git change" })

          -- Actions
          -- visual mode
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "git [s]tage hunk" })
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "git [r]eset hunk" })
          -- normal mode
          map(
            "n",
            "<leader>hs",
            gitsigns.stage_hunk,
            { desc = "git [s]tage hunk" }
          )
          map(
            "n",
            "<leader>hr",
            gitsigns.reset_hunk,
            { desc = "git [r]eset hunk" }
          )
          map(
            "n",
            "<leader>hS",
            gitsigns.stage_buffer,
            { desc = "git [S]tage buffer" }
          )
          map(
            "n",
            "<leader>hR",
            gitsigns.reset_buffer,
            { desc = "git [R]eset buffer" }
          )
          map(
            "n",
            "<leader>hp",
            gitsigns.preview_hunk,
            { desc = "git [p]review hunk" }
          )
          map(
            "n",
            "<leader>hi",
            gitsigns.preview_hunk_inline,
            { desc = "git preview hunk [i]nline" }
          )
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "git [b]lame line" })
          map(
            "n",
            "<leader>hd",
            gitsigns.diffthis,
            { desc = "git [d]iff against index" }
          )
          map("n", "<leader>hD", function()
            gitsigns.diffthis("@")
          end, { desc = "git [D]iff against last commit" })
          map("n", "<leader>hQ", function()
            gitsigns.setqflist("all")
          end, {
            desc = "git hunk [Q]uickfix list (all files in repo)",
          })
          map(
            "n",
            "<leader>hq",
            gitsigns.setqflist,
            { desc = "git hunk [q]uickfix list (all changes in this file)" }
          )
          -- Toggles
          map(
            "n",
            "<leader>tb",
            gitsigns.toggle_current_line_blame,
            { desc = "[T]oggle git show [b]lame line" }
          )
          map(
            "n",
            "<leader>tw",
            gitsigns.toggle_word_diff,
            { desc = "[T]oggle git intra-line [w]ord diff" }
          )

          -- Text object
          map({ "o", "x" }, "ih", gitsigns.select_hunk)
        end,
      },
    },

    -- Git conflict resolution
    {
      "akinsho/git-conflict.nvim",
      version = "*",
      config = true,
      event = "VeryLazy",
    },

    -- Git commands integration
    { "tpope/vim-fugitive" },

    {
      "rgroli/other.nvim",
      opts = {
        mappings = {
          "elixir",
          "golang",
          "react",
          "rust",
        },
      },
      keys = {
        {
          "<leader>oo",
          ":Other<cr>",
          noremap = true,
          silent = true,
          desc = "Other open",
        },
        {
          "<leader>ov",
          ":OtherVSplit<cr>",
          noremap = true,
          silent = true,
          desc = "Other VSplit",
        },
        {
          "<leader>os",
          ":OtherSplit<cr>",
          noremap = true,
          silent = true,
          desc = "Other Split",
        },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
      },
      lazy = false,
      keys = {
        { "<leader>-", "<CMD>Neotree<CR>", silent = true, noremap = true },
      },
      opts = {
        enable_git_status = false,
        enable_diagnostics = false,
        filesystem = {
          filtered_items = {
            hide_hidden = false,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      },
    },
    {
      "stevearc/oil.nvim",
      cmd = "Oil",
      keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      },
      opts = {
        columns = { "icon" },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<C-p>"] = false,
          ["<C-h>"] = "actions.preview",
          ["<C-v>"] = "actions.select_split",
        },
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              "branch",
              fmt = function(str)
                if #str > 15 then
                  return str:sub(1, 15) .. "..."
                end
                return str
              end,
            },
          },
          lualine_c = { { "filename", path = 3 } },
          lualine_x = {
            {
              "diff",
              colored = false,
              symbols = { added = "A:", modified = "M:", removed = "R:" },
            },
            function()
              local clients = vim.lsp.get_clients()
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return #names > 0
                  and ("[LSP: " .. table.concat(names, ", ") .. "]")
                or ""
            end,
            "diagnostics",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = { "location" },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      },
    },
    {
      "j-hui/fidget.nvim",
      opts = {
        text = {
          spinner = "dots",
        },
        align = {
          bottom = true,
        },
      },
    },

    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        fast_wrap = {
          chars = { "{", "[", "(", '"', "'", "`" },
          end_key = "L",
          highlight = "HopNextKey",
        },
      },
    },

    -- Testing
    {
      "vim-test/vim-test",
      keys = {
        {
          "<Leader>tt",
          ":w|:TestSuite<CR>",
          silent = true,
          desc = "Run test suite",
        },
        {
          "<Leader>tf",
          ":w|:TestFile<CR>",
          silent = true,
          desc = "Run test file",
        },
        {
          "<Leader>tn",
          ":w|:TestNearest<CR>",
          silent = true,
          desc = "Run nearest test",
        },
        {
          "<Leader>tl",
          ":w|:TestLast<CR>",
          silent = true,
          desc = "Run last test",
        },
      },
    },

    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        -- Adapters
        "marilari88/neotest-vitest",
        "jfpedroza/neotest-elixir",
      },
      keys = {
        {
          "<leader>mr",
          ':lua require("neotest").run.run()<cr>',
          noremap = true,
          silent = true,
          desc = "Run the nearest test",
        },
        {
          "<leader>mf",
          ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>',
          noremap = true,
          silent = true,
          desc = "Run the current file",
        },

        {
          "<leader>ms",
          '<cmd>lua require("neotest").summary.toggle()<cr>',
          noremap = true,
          silent = true,
          desc = "Toggle test summary",
        },

        {
          "<leader>mo",
          '<cmd>lua require("neotest").output.open({ enter = true, auto_close = true })<cr>',
          noremap = true,
          silent = true,
          desc = "Open test output",
        },
      },
      opts = {
        adapters = {
          ["neotest-vitest"] = {},
          ["neotest-elixir"] = {},
        },
      },
    },

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = { preset = "helix" },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },

    { import = "custom.plugins" },
  },
  change_detection = {
    notify = false,
  },
  dev = {
    -- directory where you store your local plugin projects
    path = "~/plugins",
    fallback = false,
  },
})

-- Colorscheme and highlight
-- vim.cmd("colorscheme rose-pine")
vim.cmd("colorscheme onedark")
vim.api.nvim_set_hl(0, "Whitespace", { link = "NonText" })
