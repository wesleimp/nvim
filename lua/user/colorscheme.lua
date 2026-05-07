-- Colorscheme and highlight
-- vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme default")
-- vim.cmd("colorscheme ghostty-default-style-dark")
-- vim.cmd("colorscheme onedark")
vim.cmd("colorscheme gruvbuddy")

local colorbuddy = require("colorbuddy")
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups

local bg = "#282c34"
Color.new("background", bg)
Color.new("gray0", bg)

Color.new("fg_gutter", "#5c6370")

Group.new("Normal", c.superwhite, c.gray0)
Group.new("NormalFloat", g.normal.fg:light(), g.normal.bg:dark())
Group.new("FloatBorder", c.gray0:light(), g.NormalFloat)
Group.new("LineNr", c.fg_gutter, c.gray0)
Group.new("SignColumn", c.fg_gutter, c.gray0)
Group.new("CursorLine", nil, g.normal.bg:light(0.05))
Group.new("PMenuSbar", nil, c.gray0)
Group.new("StatusLineNC", c.gray3, c.gray1:light())
Group.new("EndOfBuffer", c.gray3)
Group.new("ElNormal", c.yellow, c.background)
Group.new("ElCommand", c.orange, c.background)

-- Treesitter Context (sticky header)
Group.new("TreesitterContext", nil, g.normal.bg:light(0.08))
Group.new(
  "TreesitterContextLineNumber",
  c.fg_gutter:light(),
  g.TreesitterContext
)

-- Link Whitespace to NonText
Group.link("Whitespace", g.NonText)
