vim.keymap.set("", "<Space>", "<Nop>", { silent = true, noremap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.smartcase = true
opt.ignorecase = true
opt.inccommand = "split"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true
opt.colorcolumn = "80,120"
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.smoothscroll = true
opt.more = false
opt.winborder = "single"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.undofile = true
opt.updatetime = 250
opt.breakindent = true
opt.wrap = true
opt.linebreak = true
opt.list = true
opt.listchars = { tab = ">-", eol = "¬", lead = "·", trail = "-" }
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.shada = { "'10", "<0", "s10", "h" }
opt.formatoptions:remove("o")
vim.g.have_nerd_font = true
vim.filetype.add({
  extension = { conf = "bash" },
  pattern = {
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
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
})

require("autocmd")
require("keymaps")

-- Terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.bo.filetype = "terminal"
  end,
})
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set("n", "<leader>to", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end, { desc = "Open terminal" })

-- User commands
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line =
      vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({
    async = true,
    lsp_format = "fallback",
    range = range,
  })
end, { range = true })

vim.g.VM_leader = ","
vim.g.format_on_save = 0
vim.g.tmux_navigator_no_mappings = 1
vim.o.background = "dark"

--------------------------------------------------------------------------------
-- vim.pack: Install all plugins
--------------------------------------------------------------------------------
vim.pack.add({
  -- Libraries
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-neotest/nvim-nio",

  -- Essentials
  "https://github.com/tpope/vim-repeat",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/matze/vim-move",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/tpope/vim-speeddating",
  "https://github.com/OXY2DEV/helpview.nvim",

  -- Notification
  "https://github.com/rcarriga/nvim-notify",

  -- Icons
  "https://github.com/nvim-tree/nvim-web-devicons",

  -- Colors
  "https://github.com/nkxxll/ghostty-default-style-dark.nvim",
  "https://github.com/navarasu/onedark.nvim",
  {
    src = "https://github.com/rose-pine/neovim",
    name = "rose-pine",
  },

  -- Comment
  "https://github.com/numToStr/Comment.nvim",

  -- Git
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/akinsho/git-conflict.nvim",
  "https://github.com/tpope/vim-fugitive",

  -- File navigation
  "https://github.com/stevearc/oil.nvim",

  -- Status line
  "https://github.com/nvim-lualine/lualine.nvim",

  -- UI
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/folke/which-key.nvim",

  -- Testing
  "https://github.com/vim-test/vim-test",
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/marilari88/neotest-vitest",
  "https://github.com/jfpedroza/neotest-elixir",

  -- Telescope
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",

  -- Treesitter
  "https://github.com/wansmer/treesj",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/RRethy/nvim-treesitter-endwise",

  -- Completion
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/stevearc/conform.nvim",
})

--------------------------------------------------------------------------------
-- Plugin configuration
--------------------------------------------------------------------------------

-- Notification
local notify = require("notify")
notify.setup({ render = "simple", stages = "static" })
vim.notify = notify

-- Comment
local comment_ft = require("Comment.ft")
comment_ft.set("lua", { "--%s", "--[[%s]]" })
comment_ft.set("env", { "#%s", "#%s" })
comment_ft.set("conf", { "#%s", "#%s" })

-- Git signs
require("gitsigns").setup({
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
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
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
})

-- Git conflict
require("git-conflict").setup({})

-- Oil
require("oil").setup({
  columns = { "icon" },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["<C-p>"] = false,
    ["<C-h>"] = "actions.preview",
    ["<C-v>"] = "actions.select_split",
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Lualine
require("lualine").setup({
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
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
        return #names > 0 and ("[LSP: " .. table.concat(names, ", ") .. "]")
          or ""
      end,
      "diagnostics",
      "filetype",
    },
  },
})

-- Fidget
require("fidget").setup({
  text = {
    spinner = "dots",
  },
  align = {
    bottom = true,
  },
})

-- Autopairs
require("nvim-autopairs").setup({
  fast_wrap = {
    chars = { "{", "[", "(", '"', "'", "`" },
    end_key = "L",
    highlight = "NonText",
  },
})

-- Which-key
require("which-key").setup({ preset = "helix" })
vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- Testing: vim-test keymaps
vim.keymap.set(
  "n",
  "<Leader>tt",
  ":w|:TestSuite<CR>",
  { silent = true, desc = "Run test suite" }
)
vim.keymap.set(
  "n",
  "<Leader>tf",
  ":w|:TestFile<CR>",
  { silent = true, desc = "Run test file" }
)
vim.keymap.set(
  "n",
  "<Leader>tn",
  ":w|:TestNearest<CR>",
  { silent = true, desc = "Run nearest test" }
)
vim.keymap.set(
  "n",
  "<Leader>tl",
  ":w|:TestLast<CR>",
  { silent = true, desc = "Run last test" }
)

-- Testing: neotest
require("neotest").setup({
  adapters = {
    require("neotest-vitest"),
    require("neotest-elixir"),
  },
})
vim.keymap.set("n", "<leader>mr", function()
  require("neotest").run.run()
end, { noremap = true, silent = true, desc = "Run the nearest test" })
vim.keymap.set("n", "<leader>mf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { noremap = true, silent = true, desc = "Run the current file" })
vim.keymap.set("n", "<leader>ms", function()
  require("neotest").summary.toggle()
end, { noremap = true, silent = true, desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>mo", function()
  require("neotest").output.open({ enter = true, auto_close = true })
end, { noremap = true, silent = true, desc = "Open test output" })

--------------------------------------------------------------------------------
-- Telescope
--------------------------------------------------------------------------------
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local ignore_patterns = { ".git/", "deps/", "_build/", "node_modules/" }

telescope.setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    results_title = false,
    color_devicons = true,
    path_display = { "filename_first" },
    scroll_strategy = "cycle",
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--sort=path",
    },
    mappings = {
      i = {
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<c-c>"] = function()
          vim.cmd("stopinsert!")
        end,
        ["<C-x>"] = false,
        ["<C-q>"] = actions.send_to_qflist,
        ["<esc>"] = actions.close,
        ["<S-s>"] = actions.select_horizontal,
      },
    },
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      preview = false,
      file_ignore_patterns = ignore_patterns,
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        "--hidden",
      },
    },
    live_grep = {
      file_ignore_patterns = ignore_patterns,
    },
  },
  extensions = {
    ["ui-select"] = {
      layout_config = { horizontal = { preview_width = 0.50 } },
    },
  },
})

telescope.load_extension("ui-select")

-- Telescope keymaps
vim.keymap.set(
  "n",
  "<C-p>",
  builtin.find_files,
  { noremap = true, silent = true, desc = "Find files" }
)
vim.keymap.set("n", "<C-f>", function()
  builtin.live_grep({ hidden = true })
end, { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set(
  "n",
  "<leader>fp",
  builtin.find_files,
  { noremap = true, silent = true, desc = "Find files" }
)
vim.keymap.set("n", "<leader>fd", function()
  builtin.live_grep({ hidden = true })
end, { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set("n", "<leader>fs", function()
  builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, { noremap = true, silent = true, desc = "Grep current word" })
vim.keymap.set(
  "n",
  "<leader>ht",
  builtin.help_tags,
  { noremap = true, silent = true, desc = "Help tags" }
)
vim.keymap.set(
  "n",
  "<leader>fi",
  builtin.lsp_implementations,
  { noremap = true, silent = true, desc = "LSP Implementations" }
)
vim.keymap.set(
  "n",
  "<leader>fD",
  builtin.lsp_definitions,
  { noremap = true, silent = true, desc = "LSP Definitions" }
)
vim.keymap.set(
  "n",
  "<leader>fr",
  builtin.lsp_references,
  { noremap = true, silent = true, desc = "LSP References" }
)

require("onedark").setup({
  highlights = {
    ["@constructor"] = { fg = "$light_grey", fmt = "bold" },
    ["@punctuation.special"] = { fg = "$light_grey" },
    ["@string.special.symbol.elixir"] = { fg = "$fg" },
  },
  diagnostics = { darker = false },
})

require("user.treesitter")
require("user.lsp")

-- Colorscheme and highlight
-- vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme default")
vim.cmd("colorscheme ghostty-default-style-dark")
