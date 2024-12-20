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
  command = [[%s/\s\+$//e]],
})

-- Create folder on save if not exists
autocmd({ "BufWritePre" }, {
  group = wesleimp_group,
  pattern = "*",
  callback = function()
    require("user.mkdir").run()
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = wesleimp_group,
  pattern = { "*.dockerfile", "Dockerfile.*" },
  command = "set ft=dockerfile",
})

autocmd({ "TermOpen" }, {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = wesleimp_group,
  pattern = { "*.env", ".env.*" },
  command = "set ft=env",
})
