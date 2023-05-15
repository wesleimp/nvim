vim.opt.termguicolors = true
vim.o.background = "dark"

require("rose-pine").setup({
  groups = {},
})

vim.cmd("colorscheme rose-pine")

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

vim.cmd([[highlight IncludedC guibg=#373b41]])

hl("Bar", {
  cterm = { italic = true, bold = true },
})

hl("SignColumn", {
  bg = "none",
})

hl("LineNr", {
  bg = "none",
})
