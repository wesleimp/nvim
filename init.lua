--[[
 _      _____  _____/ /__  (_)___ ___  ____
| | /| / / _ \/ ___/ / _ \/ / __ `__ \/ __ \
| |/ |/ /  __(__  ) /  __/ / / / / / / /_/ /
|__/|__/\___/____/_/\___/_/_/ /_/ /_/ .___/
                                   /_/
--]]

pcall(require, "impatient")

require("globals")

-- require("plugins")
require("sets")
require("keymaps")
require("cmd")
require("autocmd")

vim.g.VM_leader = ","
vim.g.format_on_save = 0
vim.g.tmux_navigator_no_mappings = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("custom.plugins", {
  dev = {
    -- directory where you store your local plugin projects
    path = "~/plugins",
    fallback = false,
  },
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})
