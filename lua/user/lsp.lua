---@diagnostic disable:missing-fields

-- Completion (blink.cmp)
require("blink.cmp").setup({
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
        score_offset = 100,
      },
    },
  },
})
require("blink.cmp").build():wait(60000)

-- Lazydev (for Neovim Lua development)
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

-- Conform (formatting)
require("conform").setup({
  formatters_by_ft = {
    elixir = { "mix" },
    lua = { "stylua" },
    go = { "gofmt" },
    sql = { "pg_format", "sql-formatter" },
    markdown = { "markdownlint" },
    yaml = { "yq", "yamllint" },
    javascript = { "prettier", "biomejs", "oxfmt" },
    typescript = { "prettier", "biomejs", "oxfmt" },
    javascriptreact = { "prettier", "oxfmt" },
    typescriptreact = { "prettier", "oxfmt" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
    zig = { "zigfmt" },
    rust = { "rust_analyzer" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- LSP autocommands (document highlight, codelens)
require("user.lsp_autocommands").setup()

-- Mason
require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",
    -- "bashls",
    "gopls",
    "lua_ls",
    "rust_analyzer",
    "cssls",
    "tailwindcss",
    "zls",
    "ts_ls",
    "jsonls",
    "yamlls",
  },
  auto_update = true,
  debounce_hours = 24,
})

-- LSP capabilities (from blink.cmp)
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      lens = {
        enable = false,
      },
    },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      telemetry = { enable = false },
      hint = {
        enable = true,
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})

local ts_inlay_hints = {
  includeInlayEnumMemberValueHints = false,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = false,
  includeInlayVariableTypeHints = true,
}

vim.lsp.config("ts_ls", {
  settings = {
    javascript = { inlayHints = ts_inlay_hints },
    typescript = { inlayHints = ts_inlay_hints },
  },
})

vim.lsp.config("jsonls", {
  settings = { json = { validate = { enable = true } } },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = true,
        generate = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
        constantValues = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      semanticTokens = true,
      directoryFilters = { "-.git", "-node_modules" },
    },
  },
})

vim.lsp.config("expert", {
  cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/expert"), "--stdio" },
})

-- Enable all servers
vim.lsp.enable({
  -- "bashls",
  "gopls",
  "lua_ls",
  "rust_analyzer",
  "cssls",
  "tailwindcss",
  "zls",
  "ts_ls",
  "vue_ls",
  "jsonls",
  "yamlls",
  "expert",
  "oxlint",
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    local keymap = function(lhs, rhs, opts)
      opts =
        vim.tbl_extend("keep", opts or {}, { buffer = bufnr, silent = true })
      vim.keymap.set("n", lhs, rhs, opts)
    end

    local ts_builtin = require("telescope.builtin")
    keymap(
      "<leader>gd",
      ts_builtin.lsp_definitions,
      { desc = "Go to definition" }
    )
    keymap(
      "<leader>gr",
      ts_builtin.lsp_references,
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
      { desc = "Go to type definition" }
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
    keymap("<leader>v", function()
      vim.cmd("vsplit | lua vim.lsp.buf.definition()")
      vim.cmd("norm zz")
    end, { desc = "Definition in vsplit" })

    vim.lsp.inlay_hint.enable(true)

    keymap("<leader>gth", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints" })
  end,
})
