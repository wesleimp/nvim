return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "fang2hou/blink-copilot",
      "L3MON4D3/LuaSnip",
    },
    version = "1.*",
    setup = function()
      require("custom.snippets")
    end,
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<c-k>"] = { "snippet_forward", "fallback" },
        ["<c-j>"] = { "snippet_backward", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      cmdline = { enabled = false },
      signature = { enabled = true },
      completion = {
        documentation = { auto_show = true },
        menu = {
          draw = {
            padding = { 0, 1 },
            treesitter = { "lsp" },
            components = {
              source_name = {
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
              },
            },
            columns = {
              { "label" },
              { "kind" },
              { "source_name" },
            },
          },
        },
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
