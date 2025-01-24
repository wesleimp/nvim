---@diagnostic disable:missing-fields
require("custom.snippets")

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")

local cmp = require("cmp")
local source_mapping = {
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  path = "[Path]",
  luasnip = "[LuaSnip]",
  -- copilot = "[Copilot]",
}

cmp.setup({
  sources = {
    -- { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  },
  formatting = {
    expandable_indicator = true,
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "text",
      menu = source_mapping,
    }),
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<C-p>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "i", "c" }
    ),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "n" }),
  },

  -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})
