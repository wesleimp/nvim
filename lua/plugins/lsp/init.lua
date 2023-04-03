local autocmd = vim.api.nvim_create_autocmd
local autocmd_clear = vim.api.nvim_clear_autocmds

local cmp = require("cmp")
local luasnip = require("luasnip")

local _ = require("plugins.lsp.handlers")
local _ = require("plugins.lsp.inlay")
local codelens = require("plugins.lsp.codelens")

local source_mapping = {
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  nvim_lua = "[Lua]",
  path = "[Path]",
  luasnip = "[LuaSnip]",
}

local lspkind = require("lspkind")
lspkind.init({ mode = "text" })

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
      max_height = 15,
      max_width = 60,
    }),
  },
  mapping = {
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  formatting = {
    fields = { "abbr", "menu", "kind" },
    format = function(entry, item)
      item.kind =
        string.format("%s %s", lspkind.presets.default[item.kind], item.kind)

      item.menu = source_mapping[entry.source.name]

      return item
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    severity = nil,
    source = "if_many",
    format = nil,
  },
  signs = true,
  -- options for floating windows:
  float = {
    show_header = true,
    border = "rounded",
  },
  -- general purpose
  severity_sort = true,
  update_in_insert = false,
})

local function nmap(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

local augroup_format =
  vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })
local autocmd_format = function(async, filter)
  vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format({ async = async, filter = filter })
    end,
  })
end

local augroup_codelens =
  vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
local filetype_attach = setmetatable({
  ocaml = function()
    autocmd_format(false)

    -- Display type information
    autocmd_clear({ group = augroup_codelens, buffer = 0 })
    autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
      group = augroup_codelens,
      buffer = 0,
      callback = codelens.refresh_virtlines,
    })

    nmap(
      "<space>vl",
      codelens.toggle_virtlines,
      { silent = true, desc = "[T]oggle [T]ypes", buffer = 0 }
    )
  end,
  elixir = function()
    autocmd_format(false)
  end,
  rust = function()
    autocmd_format(false)
  end,
}, {
  __index = function()
    return function() end
  end,
})

local on_attach = function(client, bufnr)
  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }

  nmap("<leader>gD", vim.lsp.buf.declaration, opts)
  nmap("<leader>gd", vim.lsp.buf.definition, opts)
  nmap("<leader>rn", vim.lsp.buf.rename, opts)
  nmap("<leader>k", vim.lsp.buf.hover, opts)
  nmap("<leader>D", vim.lsp.buf.type_definition, opts)
  nmap("<leader>ca", vim.lsp.buf.code_action, opts)
  nmap("<leader>f", vim.lsp.buf.format or vim.lsp.buf.formatting, opts)
  nmap("<leader>sd", function()
    vim.diagnostic.open_float(0, { scope = "line" })
  end, opts)

  nmap("<space>rr", "<cmd>LspRestart<CR>", opts)

  nmap("[d", function()
    vim.diagnostic.goto_prev({
      wrap = true,
      float = true,
    })
  end, opts)

  nmap("]d", function()
    vim.diagnostic.goto_next({
      wrap = true,
      float = true,
    })
  end, opts)

  nmap("<leader>gi", function()
    require("telescope.builtin").lsp_implementations()
  end, opts)

  nmap("<leader>gr", function()
    require("telescope.builtin").lsp_references()
  end, opts)

  nmap("<leader>gs", function()
    require("telescope.builtin").lsp_document_symbols({
      ignore_filename = true,
    })
  end, opts)

  nmap("<leader>gds", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({
      ignore_filename = true,
    })
  end, opts)

  nmap("<leader>gsd", function()
    require("telescope.builtin").diagnostics({
      bufnr = bufnr,
    })
  end, opts)

  if false and client.server_capabilities.codeLensProvider then
    autocmd_clear({ group = augroup_codelens, buffer = bufnr })
    autocmd({ "BufEnter" }, {
      group = augroup_codelens,
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
      once = true,
    })
    autocmd({ "BufWritePost", "CursorHold" }, {
      group = augroup_codelens,
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
    })
  end

  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  filetype_attach[filetype]()
end

------------------------------------------------------------
-- Language servers
------------------------------------------------------------
-- Capabilities and mappings
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function config(conf)
  return vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
  }, conf or {})
end

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    "elixirls",
    "tsserver",
  },
})

-- Languages
local lspconfig = require("lspconfig")

lspconfig.tsserver.setup(config({
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
}))

lspconfig.gopls.setup(config({
  cmd = { "gopls" },
  settings = {
    gopls = { analyses = { unusedparams = true }, staticcheck = true },
  },
}))

lspconfig.elixirls.setup(config())
lspconfig.rust_analyzer.setup(config())
lspconfig.ocamllsp.setup(config())

lspconfig.lua_ls.setup(config({
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
      diagnostics = { globals = { "vim", "it", "describe" } },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  },
}))

local null_ls = require("null-ls")
null_ls.setup(config({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
  },
}))

------------------------------------------------------------
-- Snippets
------------------------------------------------------------
local snippets_paths = function()
  local plugins = { "friendly-snippets" }
  local paths = {}
  local path
  local root_path = vim.env.HOME .. "/.vim/plugged/"
  for _, plug in ipairs(plugins) do
    path = root_path .. plug
    if vim.fn.isdirectory(path) ~= 0 then
      table.insert(paths, path)
    end
  end
  return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
  paths = snippets_paths(),
  include = nil, -- Load all languages
  exclude = {},
})
