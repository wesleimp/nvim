return {
  { "ellisonleao/gruvbox.nvim" },
  { "tjdevries/colorbuddy.nvim" },
  { "tjdevries/gruvbuddy.nvim" },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  { "navarasu/onedark.nvim" },
  {
    "maxmx03/solarized.nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  {
    "norcalli/nvim-terminal.lua",
    config = function()
      require("terminal").setup()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
