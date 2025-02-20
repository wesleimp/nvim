return {
  { "lewis6991/impatient.nvim" },
  { "nvim-lua/plenary.nvim", dev = false },
  { "nvim-lua/popup.nvim" },
  "milisims/nvim-luaref",
  "tpope/vim-surround",
  "godlygeek/tabular", -- Quickly align text by pattern
  "tpope/vim-repeat", -- Repeat actions better
  "tpope/vim-abolish", -- Cool things with words!
  "tpope/vim-characterize", -- ?
  "tpope/vim-scriptease",
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
