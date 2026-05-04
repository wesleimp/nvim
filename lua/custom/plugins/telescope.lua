return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 100,
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      local open_with_trouble = require("trouble.sources.telescope").open

      local ignore_patterns = { ".git/", "deps/", "_build/", "node_modules/" }

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          results_title = false,
          color_devicons = true,
          -- path_display = { "absolute", "truncate" },
          path_display = { "filename_first" },
          -- selection_strategy = "reset",
          -- sorting_strategy = "ascending",
          scroll_strategy = "cycle",
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--sort=path",
          },
          mappings = {
            i = {
              ["<C-w>"] = actions.send_selected_to_qflist,
              ["<c-c>"] = function()
                vim.cmd("stopinsert!")
              end,
              ["<C-x>"] = false,
              ["<C-q>"] = actions.send_to_qflist,
              ["<C-l>"] = open_with_trouble,
              ["<esc>"] = actions.close,
              ["<S-s>"] = actions.select_horizontal,
            },
          },
        },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
          find_files = {
            preview = false,
            file_ignore_patterns = ignore_patterns,
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--hidden",
            },
          },
          live_grep = {
            file_ignore_patterns = ignore_patterns,
          },
        },
        extensions = {
          fzy = {
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
          },
          ["ui-select"] = {
            layout_config = { horizontal = { preview_width = 0.50 } },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      -- Old mappings
      vim.keymap.set(
        "n",
        "<C-p>",
        builtin.find_files,
        { noremap = true, silent = true, desc = "Find files" }
      )
      vim.keymap.set("n", "<C-f>", function()
        builtin.live_grep({ hidden = true })
      end, { noremap = true, silent = true, desc = "Live grep" })
      -- New mappings
      vim.keymap.set(
        "n",
        "<leader>fp",
        builtin.find_files,
        { noremap = true, silent = true, desc = "Find files" }
      )
      vim.keymap.set("n", "<leader>fd", function()
        builtin.live_grep({ hidden = true })
      end, { noremap = true, silent = true, desc = "Live grep" })
      vim.keymap.set("n", "<leader>fs", function()
        builtin.grep_string({ search = vim.fn.expand("<cword>") })
      end, { noremap = true, silent = true, desc = "Grep current word" })

      vim.keymap.set(
        "n",
        "<leader>ht",
        builtin.help_tags,
        { noremap = true, silent = true, desc = "Help tags" }
      )
      vim.keymap.set(
        "n",
        "<leader>fi",
        builtin.lsp_implementations,
        { noremap = true, silent = true, desc = "LSP Implementations" }
      )
      vim.keymap.set(
        "n",
        "<leader>fD",
        builtin.lsp_definitions,
        { noremap = true, silent = true, desc = "LSP Definitions" }
      )
      vim.keymap.set(
        "n",
        "<leader>fr",
        builtin.lsp_references,
        { noremap = true, silent = true, desc = "LSP References" }
      )
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
