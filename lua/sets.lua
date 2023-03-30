local opt = vim.opt
local g = vim.g

-- History
opt.history = 50

-- Display
opt.ls = 2
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1
opt.modeline = true
opt.ruler = true
opt.title = true
opt.number = true
opt.relativenumber = true
opt.encoding = "utf8"
opt.previewheight = 5
opt.completeopt = "menu,menuone,noselect,preview,noinsert"
opt.guifont = ""
opt.termguicolors = true
opt.list = true
opt.listchars:append("tab:→\\ ,eol:↲,nbsp:␣,trail:•")
opt.scrolloff = 5
opt.splitbelow = true
opt.splitright = true

-- Cursor highlight
opt.cursorline = true

-- Line wrapping
opt.wrap = false
opt.linebreak = true
opt.showbreak = "❯ "

-- Auto indent what you can
opt.autoindent = true
opt.smartindent = true

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true
opt.hlsearch = true
opt.showmatch = true

-- Enable jumping into files in a search buffer
opt.hidden = true

-- Make backspace a bit nicer
opt.backspace = { "indent", "start", "eol" }

-- Indentation
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.shiftround = true
opt.expandtab = true

opt.mouse = "a"
opt.colorcolumn = "80"
opt.laststatus = 2
opt.wildmenu = true
opt.wildignore:append(
  "*deps/*,*_build/*,**/coverage/*,**/node_modules/*,**/.git/*"
)

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- filetype
vim.cmd("filetype plugin indent on")
