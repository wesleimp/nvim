if true then
  return nil
end

require("elixir").setup({
  credo = {
    enable = true,
    port = 9000,
    cmd = vim.fn.expand(
      "~/OSS/credo-language-server/bin/credo-language-server"
    ),
  },
  elixirls = { enable = false },
})
