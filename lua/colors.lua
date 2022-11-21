vim.g.gruvbox_contrast_dark = "hard"

vim.cmd("syntax on")
vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

hl("Bar", {
  cterm = { italic = true, bold = true },
})

hl("SignColumn", {
  bg = "none",
})

hl("CursorLineNR", {
  bg = "none",
})
