return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      { "<leader>cp", "<cmd>Copilot panel<cr>", desc = "Open copilot panel" },
    },
    opts = {
      suggestion = { enabled = false },
      panel = {
        enabled = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
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
    },
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },
}
