local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

lualine.setup({
  options = {
    theme = "tokyonight",
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
      { "%f", separator = " " },
      "diagnostics",
    },
    lualine_x = {
      "filetype",
      "fileformat",
      "encoding",
    },
  },
  inactive_sections = {
    lualine_c = {
      { "%f" },
    },
  },
  extensions = { "nvim-tree" },
})
