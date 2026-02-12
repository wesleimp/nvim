---@diagnostic disable:missing-fields

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
    },
    config = function()
      require("neodev").setup({})

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

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
        tailwindcss = true,

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
        "delve",
        -- "tailwind-language-server",
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

          local builtin = require("telescope.builtin")
          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set(
            "n",
            "<leader>gd",
            builtin.lsp_definitions,
            { buffer = 0, desc = "Go to definition" }
          )
          vim.keymap.set(
            "n",
            "<leader>gr",
            builtin.lsp_references,
            { buffer = 0, desc = "Go to references" }
          )
          vim.keymap.set(
            "n",
            "<leader>gD",
            vim.lsp.buf.declaration,
            { buffer = 0, desc = "Go to declaration" }
          )
          vim.keymap.set(
            "n",
            "<leader>gT",
            vim.lsp.buf.type_definition,
            { buffer = 0, desc = "Go to type definition" }
          )
          vim.keymap.set(
            "n",
            "<leader>k",
            vim.lsp.buf.hover,
            { buffer = 0, desc = "Hover" }
          )
          vim.keymap.set(
            "n",
            "<leader>f",
            vim.lsp.buf.format or vim.lsp.buf.formatting,
            { buffer = 0, desc = "Format buffer" }
          )

          vim.keymap.set("n", "<space>sd", function()
            vim.diagnostic.open_float({ scope = "line" })
          end, { buffer = 0, desc = "Show diagnostics" })

          vim.keymap.set(
            "n",
            "<space>rn",
            vim.lsp.buf.rename,
            { buffer = 0, desc = "Rename" }
          )
          vim.keymap.set(
            "n",
            "<space>ca",
            vim.lsp.buf.code_action,
            { buffer = 0, desc = "Code action" }
          )

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- require("null-ls").setup({
      --   sources = { },
      -- })
    end,
  },
}
