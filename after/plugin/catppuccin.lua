local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
    return
end

catppuccin.setup({
  styles = {
    conditionals = {},
  },
  integration = {
    nvimtree = {
      enabled = true,
      show_root = true,
    },
  },
})
