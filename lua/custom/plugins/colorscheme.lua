return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = true,
          operators = false,
          folds = true,
        },
        dim_inactive = true,
        transparent_mode = false,
      })
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = { styles = { transparency = true } },
  },
  { "tjdevries/colorbuddy.nvim" },
  { "tjdevries/gruvbuddy.nvim" },
  { "datsfilipe/vesper.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        styles = {
          keywords = { italic = false },
        },
      })
    end,
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "darker",
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  { dir = "~/git/min-theme.nvim" },
}
