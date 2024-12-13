return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        filetypes = {
          javascript = true,
          typescript = true,
          elixir = true,
          lua = true,
          go = true,
          rust = true,
          ["*"] = false, -- least permissible
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
