local command = vim.api.nvim_create_user_command

-- JSON ops
if vim.fn.executable("jq") then
  command("FmtJson", "%!jq .", {})
  command("UnfmtJson", "%!jq -c .", {})
end
