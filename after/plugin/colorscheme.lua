vim.opt.termguicolors = true
vim.o.background = "dark"

require("colorbuddy").colorscheme("gruvbuddy")
require("colorizer").setup()

local c = require("colorbuddy.color").colors
local Group = require("colorbuddy.group").Group
local g = require("colorbuddy.group").groups
local s = require("colorbuddy.style").styles

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

hl("Bar", {
  cterm = { italic = true, bold = true },
})

vim.cmd([[
highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl
highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl
highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl
highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl
]])

Group.new("@variable", c.superwhite, nil)

Group.new("LspParameter", nil, nil, s.italic)
Group.new("LspDeprecated", nil, nil, s.strikethrough)
Group.new("@function.bracket", g.Normal, g.Normal)
Group.new("@variable.builtin", c.purple:light():light(), g.Normal)

Group.new("TreesitterContext", nil, g.Normal.bg:light())
Group.new("TreesitterContextLineNumber", c.blue)

Group.new("@property", c.blue)
Group.new("constant", c.orange, nil, s.none)

Group.new("@keyword", c.violet, nil, s.none)
Group.new("@keyword.faded", g.nontext.fg:light(), nil, s.none)

Group.new("VirtNonText", c.gray3:dark(), nil, s.italic)
Group.new("Function", c.yellow, nil, s.none)
Group.new("Symbol", c.violet, nil, s.none)
Group.new("LspKind", c.purple:light(), nil, g.Normal)

vim.cmd([[
  hi link @function.call.lua LuaFunctionCall
  hi link @lsp.type.variable.lua variable
  hi link @lsp.type.variable.ocaml variable
  hi link @lsp.type.variable.rust variable
  hi link @lsp.type.namespace @namespace

  hi link @normal Normal
  hi link @symbol Symbol

  hi link CmpItemKind LspKind
]])

Group.new("Normal", c.superwhite, c.gray0)
