local M = {}

local ms = require("vim.lsp.protocol").Methods

--- Check if any attached client supports a given method for a buffer.
---@param bufnr integer
---@param method string
---@return boolean
local function has_clients_with_method(bufnr, method)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method(method, bufnr) then
      return true
    end
  end
  return false
end

function M.setup()
  local group = vim.api.nvim_create_augroup("LspAutocommands", { clear = true })

  ----------------------------------------------------------------------------
  -- Document Highlight
  ----------------------------------------------------------------------------
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
      if has_clients_with_method(0, ms.textDocument_documentHighlight) then
        vim.lsp.buf.document_highlight()
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
      if has_clients_with_method(0, ms.textDocument_documentHighlight) then
        vim.lsp.buf.clear_references()
      end
    end,
    group = group,
  })

  ----------------------------------------------------------------------------
  -- Codelens
  ----------------------------------------------------------------------------
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    callback = function()
      if has_clients_with_method(0, ms.textDocument_codeLens) then
        vim.lsp.codelens.enable(true, { bufnr = 0 })
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client:supports_method(ms.textDocument_codeLens, vim.api.nvim_get_current_buf()) then
        vim.lsp.codelens.enable(false, { bufnr = 0 })
      end
    end,
    group = group,
  })
end

return M
