---@diagnostic disable: missing-fields
return {
  { "simrat39/inlay-hints.nvim" },
  { "j-hui/fidget.nvim", branch = "legacy" },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  { "scalameta/nvim-metals" },
  { "b0o/schemastore.nvim" },
  { "nvim-lua/lsp_extensions.nvim" },
  { "onsails/lspkind-nvim" },
  { "nvimtools/none-ls.nvim" },
  { "ray-x/lsp_signature.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require("mason-tool-installer").setup({
            auto_update = true,
            debounce_hours = 24,
          })
        end,
      },
      { "folke/neodev.nvim" },
      -- Formatting plugin
      { "stevearc/conform.nvim" },
      {
        "saghen/blink.cmp",
        dependencies = {
          "rafamadriz/friendly-snippets",
          { "giuxtaposition/blink-cmp-copilot" },
        },
        version = "v0.*",
        opts = {
          completion = {
            menu = {
              draw = {
                columns = {
                  { "label", "label_description", gap = 1 },
                  { "kind" },
                  { "source_name" },
                },
              },
            },
            documentation = {
              auto_show = true,
            },
          },
          keymap = {
            preset = "default",
            ["<C-m>"] = { "select_and_accept" },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-k>"] = { "snippet_forward", "fallback" },
            ["<C-j>"] = { "snippet_backward", "fallback" },
            ["<Tab>"] = { "fallback" },
          },
          appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
          },
          sources = {
            completion = {
              enable_providers = {
                "lsp",
                "path",
                "luasnip",
                "buffer",
                "copilot",
              },
            },
            providers = {
              copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                score_offset = 100,
                async = true,
                transform_items = function(_, items)
                  local CompletionItemKind =
                    require("blink.cmp.types").CompletionItemKind
                  local kind_idx = #CompletionItemKind + 1
                  CompletionItemKind[kind_idx] = "Copilot"
                  for _, item in ipairs(items) do
                    item.kind = kind_idx
                  end
                  return items
                end,
              },
            },
          },
          snippets = {
            expand = require("luasnip").lsp_expand,
            jump = function(direction)
              if direction == 1 then
                if require("luasnip").expandable() then
                  return require("luasnip").expand_or_jump()
                else
                  return require("luasnip").jumpable(1)
                    and require("luasnip").jump(1)
                end
              else
                return require("luasnip").jumpable(-1)
                  and require("luasnip").jump(-1)
              end
            end,
            active = function(filter)
              filter = filter or {}
              filter.direction = filter.direction or 1

              if filter.direction == 1 then
                return require("luasnip").expand_or_jumpable()
              else
                return require("luasnip").jumpable(filter.direction)
              end
            end,
          },
        },
      },
      opts_extend = { "sources.completion.enabled_providers" },
    },
    config = function()
      require("neodev").setup()
      require("custom.snippets")

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      local servers = {
        bashls = true,
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = true,
        rust_analyzer = true,
        cssls = true,

        -- Probably want to disable formatting for this lang server
        ts_ls = true,

        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        lexical = {
          cmd = {
            vim.fn.expand("~/.local/share/nvim/mason/bin/lexical"),
            "server",
          },
          root_dir = require("lspconfig.util").root_pattern({ "mix.exs" }),
        },

        terraformls = true,
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "stylua",
        "lua_ls",
        "delve",
        -- "tailwind-language-server",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(
            vim.lsp.get_client_by_id(args.data.client_id),
            "must have valid client"
          )

          local builtin = require("telescope.builtin")
          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set(
            "n",
            "<leader>gd",
            builtin.lsp_definitions,
            { buffer = 0 }
          )
          vim.keymap.set(
            "n",
            "<leader>gr",
            builtin.lsp_references,
            { buffer = 0 }
          )
          vim.keymap.set(
            "n",
            "<leader>gD",
            vim.lsp.buf.declaration,
            { buffer = 0 }
          )
          vim.keymap.set(
            "n",
            "<leader>gT",
            vim.lsp.buf.type_definition,
            { buffer = 0 }
          )
          vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { buffer = 0 })
          vim.keymap.set(
            "n",
            "f",
            vim.lsp.buf.format or vim.lsp.buf.formatting,
            { buffer = 0 }
          )

          vim.keymap.set("n", "<space>sd", function()
            vim.diagnostic.open_float({ scope = "line" })
          end, { buffer = 0 })

          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set(
            "n",
            "<space>ca",
            vim.lsp.buf.code_action,
            { buffer = 0 }
          )

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
    end,
  },
}
