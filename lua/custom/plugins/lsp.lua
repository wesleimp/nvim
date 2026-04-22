---@diagnostic disable:missing-fields

return {
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
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      -- Formatting plugin
      {
        "stevearc/conform.nvim",
        opts = {
          formatters_by_ft = {
            elixir = { "mix" },
            lua = { "stylua" },
            go = { "gofmt" },
            sql = { "pg_format", "sql-formatter" },
            markdown = { "markdownlint" },
            yaml = { "yq", "yamllint" },
            javascript = { "prettier", "biomejs" },
            typescript = { "prettier", "biomejs" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            ["_"] = { "trim_whitespace", "trim_newlines" },
          },
          format_after_save = false,
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities({
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true, -- needs fswatch on linux
            relativePatternSupport = true,
          },
        },
      }, true)

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
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        rust_analyzer = true,
        cssls = true,
        tailwindcss = true,

        -- Probably want to disable formatting for this lang server
        ts_ls = {
          settings = {
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },

        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
            },
          },
        },

        -- expert = true,
        expert = {
          cmd = {
            vim.fn.expand("~/.local/share/nvim/mason/bin/expert"),
            "--stdio",
          },
        },
        -- lexical = {
        --   cmd = {
        --     vim.fn.expand("~/.local/share/nvim/mason/bin/lexical"),
        --     "server",
        --   },
        --   root_dir = require("lspconfig.util").root_pattern({ "mix.exs" }),
        -- },

        biome = true,
        terraformls = true,
        nginx_language_server = true,
        pyright = true,
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
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end

        -- Only call vim.lsp.config if there are server-specific settings
        if next(config) ~= nil then
          -- Remove manual_install flag as it's not an LSP config field
          local lsp_config = vim.tbl_deep_extend("force", {}, config)
          lsp_config.manual_install = nil
          vim.lsp.config(name, lsp_config)
        end

        vim.lsp.enable(name)
      end

      local disable_semantic_tokens = {
        -- lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(
            vim.lsp.get_client_by_id(args.data.client_id),
            "must have valid client"
          )

          local keymap = function(lhs, rhs, opts)
            opts = vim.tbl_extend(
              "keep",
              opts or {},
              { buffer = bufnr, silent = true }
            )
            vim.keymap.set("n", lhs, rhs, opts)
          end

          local builtin = require("telescope.builtin")
          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          keymap(
            "<leader>gd",
            builtin.lsp_definitions,
            { desc = "Go to definition" }
          )
          keymap(
            "<leader>gr",
            builtin.lsp_references,
            { desc = "Go to references" }
          )
          keymap(
            "<leader>gD",
            vim.lsp.buf.declaration,
            { desc = "Go to declaration" }
          )
          keymap(
            "<leader>gT",
            vim.lsp.buf.type_definition,
            { buffer = 0, desc = "Go to type definition" }
          )
          keymap("<leader>k", vim.lsp.buf.hover, { desc = "Hover" })
          keymap("<leader>ff", function()
            require("conform").format(
              { async = true, lsp_format = "fallback" },
              function(err)
                if not err then
                  local mode = vim.api.nvim_get_mode().mode
                  if vim.startswith(string.lower(mode), "v") then
                    vim.api.nvim_feedkeys(
                      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                      "n",
                      true
                    )
                  end
                end
              end
            )
          end, { desc = "Format buffer" })

          keymap("<space>sd", function()
            vim.diagnostic.open_float({ scope = "line" })
          end, { desc = "Show diagnostics" })

          keymap("<space>rn", vim.lsp.buf.rename, { desc = "Rename" })
          keymap("<space>ca", vim.lsp.buf.code_action, { desc = "Code action" })

          local ms = require("vim.lsp.protocol").Methods
          if client:supports_method(ms.textDocument_codeLens, 0) then
            vim.lsp.inlay_hint.enable(true)
          end

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
    end,
  },
}
