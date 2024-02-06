return {
  { "ellisonleao/gruvbox.nvim" },
  { "tjdevries/colorbuddy.nvim" },
  { "tjdevries/gruvbuddy.nvim" },
  { "norcalli/nvim-colorizer.lua" },
  {
    "norcalli/nvim-terminal.lua",
    config = function()
      require("terminal").setup()
    end,
  },
}
