local opt = vim.opt

-- Search Settings
opt.smartcase = true -- Smart case sensitivity in search
opt.ignorecase = true -- Case insensitive search by default
opt.inccommand = "split" -- Show incremental substitution results in preview split

-- Display Settings
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.cursorcolumn = true -- Highlight current column
opt.colorcolumn = "80,120"
opt.signcolumn = "yes" -- Always show sign column
opt.scrolloff = 8 -- Lines to keep above/below cursor
opt.ruler = true -- Show cursor position
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.more = false -- Disable 'more' prompt for long messages

-- Editor Settings
opt.mouse = "a" -- Enable mouse support
opt.wrap = true -- Wrap long lines
opt.linebreak = true -- Wrap at word boundaries
opt.list = false -- Don't show invisible characters by default
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
