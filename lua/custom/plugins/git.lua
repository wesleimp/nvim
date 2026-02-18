return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        numhl = false,
        linehl = false,
        current_line_blame = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map(
            "n",
            "]c",
            "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
            { expr = true, desc = "Next git hunk" }
          )
          map(
            "n",
            "[c",
            "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
            { expr = true, desc = "Previous git hunk" }
          )

          -- Actions
          map(
            { "n", "v" },
            "<leader>hs",
            ":Gitsigns stage_hunk<CR>",
            { desc = "Stage git hunk" }
          )
          map(
            { "n", "v" },
            "<leader>hr",
            ":Gitsigns reset_hunk<CR>",
            { desc = "Reset git hunk" }
          )
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage git buffer" })
          map(
            "n",
            "<leader>hu",
            gs.undo_stage_hunk,
            { desc = "Undo stage git hunk" }
          )
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset git buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview git hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame current line" })
          map(
            "n",
            "<leader>tb",
            gs.toggle_current_line_blame,
            { desc = "Toggle current line blame" }
          )
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff this file" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "Diff this file with HEAD" })
          map(
            "n",
            "<leader>td",
            gs.toggle_deleted,
            { desc = "Toggle deleted lines" }
          )

          -- Text object
          map(
            { "o", "x" },
            "ih",
            ":<C-U>Gitsigns select_hunk<CR>",
            { desc = "Select git hunk" }
          )
        end,
      })
    end,
  },

  -- Git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    event = "VeryLazy",
  },

  -- Diff viewer
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = true,
  },

  -- Git commands integration
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gwrite",
      "Gread",
      "Gdiff",
      "Gblame",
      "Gstatus",
      "Gpush",
      "Gpull",
    },
  },
}

