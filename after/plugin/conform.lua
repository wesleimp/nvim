require("conform").setup({
  formatters_by_ft = {
    elixir = { "mix" },
    lua = { "stylua" },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf, lsp_fallback = true })
  end,
})
