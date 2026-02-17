return {
  { "lewis6991/impatient.nvim" },
  { "nvim-lua/plenary.nvim", dev = false },
  { "nvim-lua/popup.nvim" },
  "tpope/vim-repeat", -- Repeat actions better
  "tpope/vim-abolish", -- Cool things with words!
  "romainl/vim-qf",

  { "matze/vim-move" },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
  },

  {
    "luukvbaal/statuscol.nvim",
    config = function()
      require("statuscol").setup({
        setopt = true,
      })
    end,
  },
}
