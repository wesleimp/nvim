local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
    return
end

npairs.setup({
  fast_wrap = {
    chars = { "{", "[", "(", '"', "'", "`" },
    end_key = "L",
    highlight = "HopNextKey",
  },
})
