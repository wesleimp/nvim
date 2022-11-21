local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

lualine.setup {
	options = {
		icons_enabled = true,
		theme = "gruvbox",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "%f" , "diagnostics" },
		lualine_x = { "filetype", "fileformat", "encoding" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "nvim-tree" },
}
