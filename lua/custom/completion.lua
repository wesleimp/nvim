vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")
lspkind.init({
  mode = "text",
  symbol_map = {
    Copilot = "",
  },
})

local cmp = require("cmp")

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
        :match("^%s*$")
      == nil
end

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "copilot" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
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
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
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
