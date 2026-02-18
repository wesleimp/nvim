return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
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
          lualine_x = {
            function()
              local clients = vim.lsp.get_clients()
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return #names > 0 and "LSP: " .. table.concat(names, ", ") or ""
            end,
            "diagnostics",
            "filetype",
          },
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

  -- File explorer
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      {
        "<leader>-",
        function()
          require("oil").toggle_float()
        end,
        desc = "Toggle oil float",
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      { "echasnovski/mini.icons", opts = {} },
    },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<C-p>"] = false,
          ["<C-h>"] = "actions.preview",
          ["<C-v>"] = "actions.select_split",
        },
      })
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}

