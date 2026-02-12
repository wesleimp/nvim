require("conform").setup({
  formatters_by_ft = {
    elixir = { "mix" },
    lua = { "stylua" },
    go = { "gofmt" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
    javascript = { "prettier", "biomejs" },
    typescript = { "prettier", "biomejs" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({
      bufnr = args.buf or 0,
      lsp_fallback = true,
      quiet = true,
    })
  end,
})
