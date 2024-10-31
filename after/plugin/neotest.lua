local neotest = require("neotest")

neotest.setup({
  icons = {
    running_animated = {
      "⠋",
      "⠙",
      "⠹",
      "⠸",
      "⠼",
      "⠴",
      "⠦",
      "⠧",
      "⠇",
      "⠏",
    },
  },
  adapters = {
    require("neotest-elixir"),
  },
})

local group = vim.api.nvim_create_augroup("NeotestConfig", {})
for _, ft in ipairs({ "output", "attach", "summary" }) do
  vim.api.nvim_create_autocmd("FileType", {
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-output-panel",
  group = group,
  callback = function()
    vim.cmd("norm G")
  end,
})

local mappings = {
  ["<leader>nr"] = function()
    neotest.run.run(vim.fn.expand("%:p"))
  end,
  ["<leader>nx"] = function()
    neotest.run.stop()
  end,
  ["<leader>nl"] = neotest.run.run_last,
  ["<leader>na"] = neotest.run.attach,
  ["<leader>no"] = function()
    neotest.output.open({ enter = true, last_run = true })
  end,
  ["<leader>ni"] = function()
    neotest.output.open({ enter = true })
  end,
  ["<leader>ns"] = neotest.summary.toggle,
  ["<leader>ne"] = neotest.output_panel.toggle,
  ["[n"] = function()
    neotest.jump.prev({ status = "failed" })
  end,
  ["]n"] = function()
    neotest.jump.next({ status = "failed" })
  end,
}

for keys, mapping in pairs(mappings) do
  vim.api.nvim_set_keymap("n", keys, "", { callback = mapping, noremap = true })
end
