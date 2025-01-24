return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
          },
        },
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
      -- require("copilot_cmp").setup()
    end,
  },
}
