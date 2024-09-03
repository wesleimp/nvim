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

if vim.o.background == "light" then
  vim.cmd([[colorscheme onedark]])
else
  vim.cmd([[colorscheme gruvbox]])
end
