local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

lualine.setup({
  options = {
    theme = "gruvbox",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {
      { "filetype", icon_only = true, separator = "" },
      { "%f", separator = "" },
    },
    lualine_c = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {
      { "filetype", icon_only = true, separator = "" },
      { "%f", separator = "" },
    },
    lualine_c = {},
  },
  sections = {
    lualine_b = { { "branch", icon = "" } },
    lualine_c = {
      { "%=%f", separator = "" },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        sections = { "error", "warn", "info" },
      },
      "filetype",
    },
  },
  inactive_sections = {
    lualine_b = {},
    lualine_c = {
      { "filename" },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        sections = { "error", "warn", "info" },
      },
      "filetype",
    },
  },
  extensions = { "nvim-tree" },
})
