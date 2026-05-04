return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  branch = "main",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },
  main = "nvim-treesitter",
  init = function()
    require("treesitter-context").setup({
      multiline_threshold = 1,
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    local ensureInstalled = {
      "awk",
      "bash",
      "cpp",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "elixir",
      "erlang",
      "fish",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "graphql",
      "hcl",
      "heex",
      "html",
      "http",
      "ini",
      "javascript",
      "jq",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "sql",
      "ssh_config",
      "templ",
      "terraform",
      "toml",
      "vim",
      "vimdoc",
      "yaml",
    }
    local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    local parsersToInstall = vim
      .iter(ensureInstalled)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    require("nvim-treesitter").install(parsersToInstall)

    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local ts_select = require("nvim-treesitter-textobjects.select")
    local ts_move = require("nvim-treesitter-textobjects.move")
    local ts_swap = require("nvim-treesitter-textobjects.swap")

    -- select
    vim.keymap.set({ "x", "o" }, "af", function()
      ts_select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Textobj: outer function" })
    vim.keymap.set({ "x", "o" }, "if", function()
      ts_select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Textobj: inner function" })
    vim.keymap.set({ "x", "o" }, "ac", function()
      ts_select.select_textobject("@conditional.outer", "textobjects")
    end, { desc = "Textobj: outer conditional" })
    vim.keymap.set({ "x", "o" }, "ic", function()
      ts_select.select_textobject("@conditional.inner", "textobjects")
    end, { desc = "Textobj: inner conditional" })
    vim.keymap.set({ "x", "o" }, "aa", function()
      ts_select.select_textobject("@parameter.outer", "textobjects")
    end, { desc = "Textobj: outer parameter" })
    vim.keymap.set({ "x", "o" }, "ia", function()
      ts_select.select_textobject("@parameter.inner", "textobjects")
    end, { desc = "Textobj: inner parameter" })
    vim.keymap.set({ "x", "o" }, "av", function()
      ts_select.select_textobject("@variable.outer", "textobjects")
    end, { desc = "Textobj: outer variable" })
    vim.keymap.set({ "x", "o" }, "iv", function()
      ts_select.select_textobject("@variable.inner", "textobjects")
    end, { desc = "Textobj: inner variable" })

    -- move
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      ts_move.goto_next_start("@function.inner", "textobjects")
    end, { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "]c", function()
      ts_move.goto_next_start("@class.inner", "textobjects")
    end, { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]a", function()
      ts_move.goto_next_start("@parameter.inner", "textobjects")
    end, { desc = "Next parameter start" })
    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      ts_move.goto_next_end("@function.inner", "textobjects")
    end, { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "]C", function()
      ts_move.goto_next_end("@class.inner", "textobjects")
    end, { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "]A", function()
      ts_move.goto_next_end("@parameter.inner", "textobjects")
    end, { desc = "Next parameter end" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      ts_move.goto_previous_start("@function.inner", "textobjects")
    end, { desc = "Prev function start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function()
      ts_move.goto_previous_start("@class.inner", "textobjects")
    end, { desc = "Prev class start" })
    vim.keymap.set({ "n", "x", "o" }, "[a", function()
      ts_move.goto_previous_start("@parameter.inner", "textobjects")
    end, { desc = "Prev parameter start" })
    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      ts_move.goto_previous_end("@function.inner", "textobjects")
    end, { desc = "Prev function end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", function()
      ts_move.goto_previous_end("@class.inner", "textobjects")
    end, { desc = "Prev class end" })
    vim.keymap.set({ "n", "x", "o" }, "[A", function()
      ts_move.goto_previous_end("@parameter.inner", "textobjects")
    end, { desc = "Prev parameter end" })

    -- swap
    vim.keymap.set("n", "<leader>a", function()
      ts_swap.swap_next("@parameter.inner")
    end, { desc = "Swap next parameter" })
    vim.keymap.set("n", "<leader>A", function()
      ts_swap.swap_previous("@parameter.inner")
    end, { desc = "Swap prev parameter" })
  end,
}
