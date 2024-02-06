return {
  { "lewis6991/impatient.nvim" },
  { "nvim-lua/plenary.nvim", dev = false },
  { "nvim-lua/popup.nvim" },
  { "tjdevries/cyclist.vim" },
  { "tjdevries/express_line.nvim", dev = false },
  { "tjdevries/overlength.vim" },

  { "tjdevries/green_light.nvim" },

  "milisims/nvim-luaref",
  "tpope/vim-surround",
  "godlygeek/tabular", -- Quickly align text by pattern
  "tpope/vim-repeat", -- Repeat actions better
  "tpope/vim-abolish", -- Cool things with words!
  "tpope/vim-characterize", -- ?
  "tpope/vim-scriptease",
  "romainl/vim-qf",

  "mkitt/tabline.vim",
  "monaqa/dial.nvim",

  { "matze/vim-move" },

  {
    "luukvbaal/statuscol.nvim",
    config = function()
      require("statuscol").setup({
        setopt = true,
      })
    end,
  },

  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
}
