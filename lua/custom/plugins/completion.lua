return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priotity = 100,
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "onsails/lspkind-nvim" },
      { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
      { "tamago324/cmp-zsh" },
    },
    config = function()
      require("custom.completion")
    end,
  },
}
