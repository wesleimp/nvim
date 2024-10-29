vim.opt.termguicolors = true
vim.o.background = "dark"

require("gruvbox").setup({})

require("catppuccin").setup({
  styles = {
    -- Handles the styles of general hi groups (see `:h highlight-args`):
    conditionals = {},
  },
  integrations = {
    fidget = true,
    notify = true,
    neotest = false,
  },
})

require("onedark").setup({
  style = "warm",
})

require("solarized").setup({})

require("colorbuddy").colorscheme("gruvbuddy")

if vim.o.background == "light" then
  vim.cmd([[colorscheme onedark]])
else
  vim.cmd([[colorscheme gruvbuddy]])
end

--
local colorbuddy = require("colorbuddy")
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups
--
-- Color.new("white", "#cccccc")
-- Color.new("red", "#cc5555")
-- Color.new("pink", "#cc55cc")
-- Color.new("green", "#55cc55")
-- Color.new("yellow", "#cdcd55")
-- Color.new("blue", "#5455cb")
-- Color.new("aqua", "#8ec07c")
-- Color.new("cyan", "#8abeb7")
-- Color.new("purple", "#8e6fbd")
-- Color.new("violet", "#b294bb")
-- Color.new("orange", "#de935f")
-- Color.new("brown", "#a3685a")
--
local background_string = "#191919"
Color.new("background", background_string)
Color.new("gray0", background_string)
--
-- Group.new("Normal", c.superwhite, c.gray0)
--
-- Group.new("@constant", c.violet, nil, s.none)
-- Group.new("@function", c.white, nil, s.none)
-- Group.new("@function.bracket", g.Normal, g.Normal)
-- Group.new("@keyword", c.violet, nil, s.none)
-- Group.new("@keyword.faded", g.nontext.fg:light(), nil, s.none)
-- Group.new("@property", c.white)
-- Group.new("@variable", c.white, nil)
-- Group.new("@variable.builtin", c.purple, g.Normal)
--
-- -- I've always liked lua function calls to be blue. I don't know why.
Group.new("@function.call.lua", c.blue:dark(), nil, nil)
Group.link("@macro", g.keyword)
Group.link("@structure", g.variable)
Group.link("@string.special.symbol", g.keyword)
