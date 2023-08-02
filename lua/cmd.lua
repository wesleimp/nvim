local command = vim.api.nvim_create_user_command

-- JSON ops
if vim.fn.executable("jq") then
  command("FmtJson", "%!jq .", {})
  command("UnfmtJson", "%!jq -c .", {})
end

command("FmtFile", function()
  local filetype = vim.bo.filetype
  if filetype == "elixir" then
    vim.cmd("!mix format %")
  end
end, {})

if vim.fn.executable("format-sql") then
  command("FormatSQL", function()
    require("plugins.format_sql").format()
  end, {})
end

command("FormatRange", function(cmd)
  local bufnr = vim.api.nvim_get_current_buf()
  require("plugins.format_range").format(
    bufnr,
    { start = cmd.line1, finish = cmd.line2 }
  )
end, { range = 2 })
