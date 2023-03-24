vim.opt.termguicolors = true

require("rose-pine").setup({
  groups = {
    background = "#000000"
  }
})

vim.cmd([[colorscheme rose-pine]])

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
