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
  ["<leader>nr"] = {
    callback = function()
      neotest.run.run(vim.fn.expand("%:p"))
    end,
    desc = "Run tests in current file",
  },
  ["<leader>nx"] = {
    callback = function()
      neotest.run.stop()
    end,
    desc = "Stop running tests",
  },
  ["<leader>nl"] = { callback = neotest.run.run_last, desc = "Run last test" },
  ["<leader>na"] = { callback = neotest.run.attach, desc = "Attach to test" },
  ["<leader>no"] = {
    callback = function()
      neotest.output.open({ enter = true, last_run = true })
    end,
    desc = "Open output for last run",
  },
  ["<leader>ni"] = {
    callback = function()
      neotest.output.open({ enter = true })
    end,
    desc = "Open output for current test",
  },
  ["<leader>ns"] = {
    callback = neotest.summary.toggle,
    desc = "Toggle summary",
  },
  ["<leader>ne"] = {
    callback = neotest.output_panel.toggle,
    desc = "Toggle output panel",
  },
  ["[n"] = {
    callback = function()
      neotest.jump.prev({ status = "failed" })
    end,
    desc = "Previous failed test",
  },
  ["]n"] = {
    callback = function()
      neotest.jump.next({ status = "failed" })
    end,
    desc = "Next failed test",
  },
}

for keys, mapping in pairs(mappings) do
  vim.api.nvim_set_keymap(
    "n",
    keys,
    "",
    { callback = mapping.callback, desc = mapping.desc, noremap = true }
  )
end
