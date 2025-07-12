local function lsp_clients()
  return require("lsp-progress").progress({
    format = function(_)
      local active_clients = vim.lsp.get_clients()
      local client_names = {}
      for _, client in ipairs(active_clients) do
        if client and client.name ~= "" then
          table.insert(client_names, "[" .. client.name .. "]")
        end
      end
      return "LSP:" .. table.concat(client_names, "")
    end,
  })
end

return {
  {
    "linrongbin16/lsp-progress.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lsp-progress").setup({})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              "branch",
              fmt = function(str)
                if #str > 15 then
                  return str:sub(1, 15) .. "..."
                end
                return str
              end,
            },
            "diff",
          },
          lualine_c = { { "filename", path = 3 } },
          lualine_x = { lsp_clients, "diagnostics", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = { "location" },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
