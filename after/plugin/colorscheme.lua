vim.opt.termguicolors = true

-- require("gruvbox").setup({
--   italic = false,
--   contrast = "hard", -- can be "hard", "soft" or empty string
-- })

require("tokyonight").setup({
  style = "night",
  styles = {
    keywords = { italic = false}
  }
})
vim.cmd([[colorscheme tokyonight]])

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
