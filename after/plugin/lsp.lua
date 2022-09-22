local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local ismac = vim.fn.has("macunix") == 1

-- Setup nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")

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
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      vim_item.menu = source_mapping[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Auto Formatter
local augroup_format =
  vim.api.nvim_create_augroup("wesleimp_lsp_format", { clear = true })

local autocmd_format = function(opts)
  opts = opts or {}
  vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = opts.callback or function()
      vim.lsp.buf.formatting({
        async = opts.async or false,
        filter = opts.filter,
      })
    end,
  })
end

local filetype_attach = setmetatable({
  elixir = function()
    autocmd_format()
  end,

  go = function()
    autocmd_format()
  end,

  rust = function()
    autocmd_format()
  end,

  lua = function()
    autocmd_format({
      callback = function()
        require("stylua").format()
      end,
    })
  end,

  scss = function()
    autocmd_format()
  end,

  css = function()
    autocmd_format()
  end,

  typescript = function()
    autocmd_format({
      filter = function(clients)
        return vim.tbl_filter(function(client)
          return client.name ~= "tsserver"
        end, clients)
      end,
    })
  end,
}, {
  __index = function()
    return function() end
  end,
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
    format = function(d)
      if not d.code and not d.user_data then
        return d.message
      end

      local t = vim.deepcopy(d)
      local code = d.code
      if not code then
        if not d.user_data.lsp then
          return d.message
        end

        code = d.user_data.lsp.code
      end
      if code then
        t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
      end
      return t.message
    end,
  },

  -- general purpose
  severity_sort = true,
  update_in_insert = false,
})

-- Go to the next diagnostic, but prefer going to errors first
-- In general, I pretty much never want to go to the next hint
local severity_levels = {
  vim.diagnostic.severity.ERROR,
  vim.diagnostic.severity.WARN,
  vim.diagnostic.severity.INFO,
  vim.diagnostic.severity.HINT,
}

local function get_highest_error_severity()
  for _, level in ipairs(severity_levels) do
    local diags = vim.diagnostic.get(0, { severity = { min = level } })
    if #diags > 0 then
      return level, diags
    end
  end
end

local function nmap(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

local on_attach = function(_, bufnr)
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

  nmap("[d", function()
    vim.diagnostic.goto_prev({
      severity = get_highest_error_severity(),
      wrap = true,
      float = true,
    })
  end, opts)

  nmap("]d", function()
    vim.diagnostic.goto_next({
      severity = get_highest_error_severity(),
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

  -- Attach any filetype specific options to the client
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  filetype_attach[filetype]()
end

------------------------------------------------------------
-- Language servers
------------------------------------------------------------
-- Capabilities and mappings
local function config(conf)
  return vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
  }, conf or {})
end

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
lspconfig.cssls.setup(config())

lspconfig.yamlls.setup(config({
  settings = {
    yaml = {
      schemaStore = {
        url = "https://www.schemastore.org/api/json/catalog.json",
        enable = true,
      },
    },
  },
}))

lspconfig.dockerls.setup(config())

-- I'll uncomment this when I need it
-- lspconfig.svelte.setup(config()) -- svelte
-- lspconfig.gleam.setup(config())  -- gleam
-- lspconfig.hls.setup(config())    -- haskell
lspconfig.pyright.setup(config()) -- python

lspconfig.gopls.setup(config({
  cmd = { "gopls" },
  settings = {
    gopls = { analyses = { unusedparams = true }, staticcheck = true },
  },
}))

if ismac then
  lspconfig.elixirls.setup(config({
    cmd = { "elixir-ls" },
  }))
else
  lspconfig.elixirls.setup(config({
    cmd = { vim.fn.expand("~/elixir-ls/release/language_server.sh") },
  }))
end

lspconfig.rust_analyzer.setup(config())

local luacmd
if ismac then
  luacmd = { "lua-language-server" }
else
  local sumneko_root_path = vim.fn.expand("~/lua-language-server")
  local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
  luacmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" }
end
lspconfig.sumneko_lua.setup(config({
  cmd = luacmd,
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
  exclude = { "elixir" },
})
