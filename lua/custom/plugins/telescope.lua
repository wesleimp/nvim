return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 100,
    config = function()
      require("user.telescope")
    end,
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-hop.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "junegunn/fzf", build = "./install --all" },
  { "junegunn/fzf.vim" },

  {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require("neoclip").setup()
    end,
  },
}
