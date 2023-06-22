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
