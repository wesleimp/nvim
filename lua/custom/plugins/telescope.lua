return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 100,
    config = function()
      require("user.telescope")
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
