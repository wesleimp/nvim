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
          "lsp",
          "path",
          "buffer",
          "snippets",
        },
        providers = {
          lsp = {
            fallbacks = { "lazydev" },
          },
        },
      },
    },
  },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
          },
        },
        filetypes = {
          javascript = true,
          typescript = true,
          elixir = true,
          lua = true,
          go = true,
          rust = true,
          ["*"] = false, -- least permissible
        },
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        fast_wrap = {
          chars = { "{", "[", "(", '"', "'", "`" },
          end_key = "L",
          highlight = "HopNextKey",
        },
      })
    end,
  },
}
