local ok, zen = pcall(require, "zen-mode")
if not ok then
    return
end

zen.setup({
  window = {
    backdrop = 1,
    widht = 140,
  },
  plugins = {
    twilight = {
      enabled = false,
    },
    tmux = {
      enabled = false,
    },
  },
})
