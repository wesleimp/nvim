local augroup = vim.api.nvim_create_augroup
local wesleimp_group = augroup("wesleimp", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

-- =======================================
-- Neotest
-- =======================================
local group = augroup("NeotestConfig", {})
for _, ft in ipairs({ "output", "attach", "summary" }) do
  autocmd("FileType", {
    pattern = "neotest-" .. ft,
    group = group,
    callback = function(opts)
      vim.keymap.set("n", "q", function()
        pcall(vim.api.nvim_win_close, 0, true)
      end, {
        buffer = opts.buf,
      })
    end,
  })
end

autocmd("FileType", {
  pattern = "neotest-output-panel",
  group = group,
  callback = function()
    vim.cmd("norm G")
  end,
})

-- =======================================
-- General
-- =======================================
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
-- autocmd({ "BufWritePre" }, {
--   group = wesleimp_group,
--   pattern = "*",
--   command = [[%s/\s\+$//e]],
-- })

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
