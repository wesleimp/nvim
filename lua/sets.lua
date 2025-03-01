---@diagnostic disable: missing-fields
local opt = vim.opt

----- Interesting Options -----
vim.g.have_nerd_font = true

-- You have to turn this one on :)
opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }
opt.swapfile = false
opt.backspace = { "indent", "start", "eol" }
opt.listchars = {
  tab = "→\\ ",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
}

-- Don't have `o` add a comment
opt.formatoptions:remove("o")
opt.wrap = true
opt.linebreak = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.termguicolors = true
opt.cursorline = true
opt.cursorcolumn = true
opt.scrolloff = 8
-- opt.colorcolumn = "80"
-- opt.signcolumn = "yes"

opt.more = false

opt.ruler = true
