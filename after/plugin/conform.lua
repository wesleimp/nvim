require("conform").setup({
  formatters_by_ft = {
    elixir = { "mix" },
    lua = { "stylua" },
    go = { "gofmt" },
    json = { "jq" },
    sql = { "pg_format", "sql-formatter" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
    javascript = { "prettier", "biomejs" },
    typescript = { "prettier", "biomejs" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
  },
  format_after_save = {
    lsp_fallback = true,
  },
})
