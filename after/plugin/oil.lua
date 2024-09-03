require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["<C-p>"] = false,
    ["<C-h>"] = "actions.preview",
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
