local ok, bl = pcall(require, "indent_blankline")
if not ok then
    return
end

bl.setup({
  char = "▏",
  context_char = "▏",
  show_first_indent_level = false,
  show_trailing_blankline_indent = false,
  filetype_exclude = {
    "help",
    "markdown",
    "gitcommit",
    "packer",
    "NvimTree",
  },
  buftype_exclude = { "terminal", "nofile" },
  use_treesitter = true,
})
