vim.api.nvim_set_keymap(
  "n",
  "<leader>cc",
  [[:lua require("user.telescope.credo").issues()<CR>]],
  { noremap = true, silent = true }
)
