require("mix-credo").setup({
  patterns = { "*.ex", "*.exs" }, -- for augroup
  mappings = {
    warning = vim.diagnostic.severity.ERROR,
    consistency = vim.diagnostic.severity.WARN,
    readability = vim.diagnostic.severity.HINT,
    refactor = vim.diagnostic.severity.HINT,
    desingn = vim.diagnostic.severity.HINT,
  },
})
