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
  sections = {
    lualine_b = { { "branch" } },
    lualine_c = {
      { "%f", separator = "" },
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        sections = { "error", "warn", "info" },
      },
    },
    lualine_x = {
      require("plugins.pomodoro").status,
      "encoding",
      "fileformat",
      "filetype",
    },
  },
  extensions = { "nvim-tree" },
})
