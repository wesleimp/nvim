return {
  -- Main completion engine
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    version = "1.*",
    event = "InsertEnter",
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
        use_nvim_cmp_as_default = false,
      },
      cmdline = { enabled = false },
      signature = { enabled = true },
      completion = {
        documentation = { auto_show = true },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
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
      sources = {
        default = {
          "lazydev",
          "lsp",
          "path",
          "buffer",
          "snippets",
        },
        providers = {
          lsp = {
            fallbacks = { "lazydev" },
            min_keyword_length = 0,
            score_offset = 0,
          },
          path = {
            min_keyword_length = 0,
          },
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            min_keyword_length = 5,
            max_items = 5,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
}
