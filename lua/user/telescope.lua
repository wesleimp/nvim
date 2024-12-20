local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local credo_ext = require("user.telescope.credo")

local bchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

local function dropdown(opts)
  return themes.get_dropdown(vim.tbl_deep_extend("force", opts or {}, {
    borderchars = {
      bchars,
      prompt = bchars,
      results = bchars,
      preview = bchars,
    },
  }))
end

telescope.setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    results_title = false,

    color_devicons = true,
    selection_strategy = "reset",
    sorting_strategy = "ascending",

    scroll_strategy = "cycle",
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    file_previewer = previewers.vim_buffer_cat.new,

    borderchars = bchars,
    path_display = { "absolute", "truncate" },
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.5,
      },
    },
    winblend = 0,
    mappings = {
      i = {
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<c-c>"] = function()
          vim.cmd("stopinsert!")
        end,
        ["<C-x>"] = false,
        ["<C-q>"] = actions.send_to_qflist,
        ["<esc>"] = actions.close,
        ["<S-s>"] = actions.select_horizontal,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
      },
    },
  },
  pickers = {
    colorscheme = { enable_preview = true },
    find_files = {
      hidden = true,
      file_ignore_patterns = { ".git/", "deps/", "_build/" },
      previewer = false,
    },
    live_grep = {
      file_ignore_patterns = { ".git/", "deps/", "_build/" },
    },
    buffers = {
      sort_mru = true,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      previewer = false,
      mappings = {
        i = { ["<c-x>"] = "delete_buffer" },
        n = { ["<c-x>"] = "delete_buffer" },
      },
    },
    git_branches = dropdown(),
    git_bcommits = {
      layout_config = { horizontal = { preview_width = 0.55 } },
    },
    git_commits = {
      layout_config = { horizontal = { preview_width = 0.55 } },
    },
    diagnostics = {
      path_display = { "tail" },
    },
  },
  extensions = {
    credo = credo_ext,
    fzy = {
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
    },
    ["ui-select"] = {
      layout_config = { horizontal = { preview_width = 0.55 } },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("notify")
telescope.load_extension("neoclip")

local M = {}
M.search_dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "< .dotfiles >",
    cwd = vim.env.DOTFILES,
    hidden = true,
  })
end

M.search_nvimconf = function()
  require("telescope.builtin").find_files({
    prompt_title = "< Nvim >",
    cwd = vim.env.NVIMCONF,
    hidden = true,
  })
end

return M
