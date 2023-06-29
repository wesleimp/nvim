local Job = require("plenary.job")

local function run_formatter(text)
  local split = vim.split(text, "\n")
  local result = table.concat(vim.list_slice(split, 2, #split - 1), "\n")

  local bin = vim.api.nvim_get_runtime_file("bin/format-sql.py", false)[1]

  return Job:new({
    command = "python3",
    args = { bin },
    writer = { result },
  }):sync()
end

local embedded_sql = vim.treesitter.query.parse(
  "elixir",
  [[
(call
  target: ((identifier) @_identifier (#eq? @_identifier "execute"))
  (arguments
    (string
      (quoted_content) @sql))
  (#offset! @sql 1 0 -1 0))
]]
)

local function root_node(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "elixir", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local M = {}

function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= "elixir" then
    vim.notify("FormatSQL can only be used with elixir")
    return
  end

  local root = root_node(bufnr)

  local changes = {}
  for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_sql.captures[id]
    if name == "sql" then
      -- {start row, start col, end row, end col}
      local range = { node:range() }
      local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))

      table.insert(changes, 1, {
        start = range[1] + 1,
        finish = range[3],
        formatted = formatted,
      })
    end
  end

  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(
      bufnr,
      change.start,
      change.finish,
      false,
      change.formatted
    )
  end
end

return M
