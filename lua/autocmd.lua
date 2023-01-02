local augroup = vim.api.nvim_create_augroup
local wesleimp_group = augroup("wesleimp", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- Substitute trainling space
autocmd({ "BufWritePre" }, {
  group = wesleimp_group,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Create folder on save if not exists
autocmd({ "BufWritePre" }, {
  group = wesleimp_group,
  pattern = "*",
  callback = function()
    require("plugins.mkdir").run()
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = wesleimp_group,
  pattern = { "*.dockerfile", "Dockerfile.*" },
  command = "set ft=dockerfile",
})

-- Toggle relative numbers when leave or enter buffer
local numtoggle_group = augroup("numtoggle", {})
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
   pattern = "*",
   group = numtoggle_group,
   callback = function()
      if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
         vim.opt.relativenumber = true
      end
   end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
   pattern = "*",
   group = numtoggle_group,
   callback = function()
      if vim.o.nu then
         vim.opt.relativenumber = false
         vim.cmd "redraw"
      end
   end,
})
