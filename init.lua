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
opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

opt.foldmethod = "manual"

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
  "https://github.com/tjdevries/colorbuddy.nvim",
  "https://github.com/folke/tokyonight.nvim",

  -- Comment
  "https://github.com/numToStr/Comment.nvim",

  -- Git
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/akinsho/git-conflict.nvim",
  "https://github.com/tpope/vim-fugitive",

  -- File navigation
  "https://github.com/stevearc/oil.nvim",

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

-- Experimental UI2: floating cmdline and messages
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      bufwrite = "msg",
      confirm = "cmd",
      emsg = "pager",
      echo = "msg",
      echomsg = "msg",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "msg",
      progress = "pager",
      rpc_error = "pager",
      quickfix = "msg",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "msg",
      undo = "pager",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})

require("tokyonight").setup({
  style = "storm",
  styles = {
    keywords = { italic = false },
  },
})
vim.cmd.colorscheme("tokyonight")

-- Notification
local notify = require("notify")
notify.setup({ render = "simple", stages = "static" })
vim.notify = notify

require("user.statusline")

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

require("user.telescope")
require("user.treesitter")
require("user.lsp")
