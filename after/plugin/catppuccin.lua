local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
  return
end

catppuccin.setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  term_colors = true,
  transparent_background = true,
  compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
  },
  color_overrides = {
    mocha = {
      base = "#1d2021",
      mantle = "#1d2021",
      crust = "#1d2021",
    },
  },
})
