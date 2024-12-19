vim.opt.termguicolors = true
vim.o.background = "dark"

local function sort() end
-- require("colorbuddy").colorscheme("gruvbuddy")
--
vim.cmd("colorscheme mellifluous")
--
-- local colorbuddy = require("colorbuddy")
-- local Color = colorbuddy.Color
-- local Group = colorbuddy.Group
-- local c = colorbuddy.colors
-- local g = colorbuddy.groups
--
-- local background_string = "#191919"
-- Color.new("background", background_string)
-- Color.new("gray0", background_string)
--
-- -- -- I've always liked lua function calls to be blue. I don't know why.
-- Group.new("@function.call.lua", c.blue:dark(), nil, nil)
-- Group.link("@macro", g.keyword)
-- Group.link("@structure", g.variable)
-- Group.link("@string.special.symbol", g.keyword)
