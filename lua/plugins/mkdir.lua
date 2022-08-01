local M = {}

function M.run()
  local dir = vim.fn.expand("<afile>:p:h")
  if dir:find("%l+://") == 1 then
    return
  end

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

return M
