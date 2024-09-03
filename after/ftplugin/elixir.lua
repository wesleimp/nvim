vim.api.nvim_set_keymap(
  "n",
  "<leader>cc",
  [[:lua require("w.telescope.credo").issues()<CR>]],
  { noremap = true, silent = true }
)
