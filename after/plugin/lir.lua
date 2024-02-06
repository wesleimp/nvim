local has_lir, lir = pcall(require, "lir")
if not has_lir then
  return
end

local has_devicons, devicons = pcall(require, "nvim-web-devicons")
if has_devicons then
  devicons.setup({
    override = {
      lir_folder_icon = {
        icon = "",
        color = "#7ebae4",
        name = "LirFolderNode",
      },
    },
  })
end

local actions = require("lir.actions")
local has_mmv, mmv_actions = pcall(require, "lir.mmv.actions")

lir.setup({
  show_hidden_files = true,
  devicons = {
    enable = true,
  },

  float = { winblend = 15 },

  mappings = {
    ["<CR>"] = actions.edit,
    ["-"] = actions.up,

    ["K"] = actions.mkdir,
    ["N"] = actions.newfile,
    ["R"] = actions.rename,
    ["Y"] = actions.yank_path,
    ["D"] = actions.delete,
    ["."] = actions.toggle_show_hidden,

    -- mmv
    ["M"] = (has_mmv and mmv_actions.mmv) or nil,
  },
})

require("lir.git_status").setup({
  show_ignored = false,
})

vim.api.nvim_set_keymap("n", "-", ":edit %:h<CR>", { noremap = true })
