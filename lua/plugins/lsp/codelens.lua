local M = {}

local virtlines_enabled = true
M.toggle_virtlines = function()
  virtlines_enabled = not virtlines_enabled
  M.refresh_virtlines()
end

M.refresh_virtlines = function()
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
  }

  vim.lsp.buf_request(
    0,
    "textDocument/codeLens",
    params,
    function(err, result, _, _)
      if err then
        return
      end

      local ns = vim.api.nvim_create_namespace("custom-lsp-codelens")
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

      if not virtlines_enabled then
        return
      end

      for _, lens in ipairs(result) do
        local title = lens.command.title
        local range = lens.range
        local text = string.rep(" ", lens.range.start.character) .. title

        print(vim.inspect(range))
        vim.api.nvim_buf_set_extmark(0, ns, range.start.line - 1, 0, {
          virt_lines = {
            { { text, "VirtNonText" } },
          },
        })
      end
    end
  )
end

return M
