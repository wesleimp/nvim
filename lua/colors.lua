if not pcall(require, "colorbuddy") then
  return
end

vim.opt.termguicolors = true

require("colorbuddy").colorscheme("gruvbuddy")
require("colorizer").setup()

local c = require("colorbuddy.color").colors
local Group = require("colorbuddy.group").Group
local g = require("colorbuddy.group").groups
local s = require("colorbuddy.style").styles

Group.new("@variable", c.superwhite, nil)

Group.new("InjectedLanguage", nil, g.Normal.bg:dark())

Group.new("LspParameter", nil, nil, s.italic)
Group.new("@function.bracket", g.Normal, g.Normal)
Group.new("LspDeprecated", nil, nil, s.strikethrough)

-- Group.new("@function.call.lua"
vim.cmd([[highlight link @function.call.lua LuaFunctionCall]])

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

hl("Bar", {
  cterm = { italic = true, bold = true },
})

hl("SignColumn", {
  bg = "none",
})

hl("LineNr", {
  bg = "none",
})

hl("LineNmu", {
  bg = "#333842",
})

hl("ColorColumn", {
  bg = "#333842",
})
