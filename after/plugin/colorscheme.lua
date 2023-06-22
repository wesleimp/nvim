vim.opt.termguicolors = true
vim.o.background = "dark"

require("gruvbox").setup({
  contrast = "hard",
  bold = false,
})

-- vim.cmd("colorscheme gruvbox")

require("colorbuddy").colorscheme("sitrusbuddy")

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

vim.cmd([[
highlight IncludedC guibg=#373b41

highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl
highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl
highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl
highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl

highlight link LspReferenceRead DiffChange
highlight link LspReferenceText DiffChange
highlight link LspReferenceWrite DiffChange
highlight link LspSignatureActiveParameter GruvboxOrange
]])

hl("Bar", {
  cterm = { italic = true, bold = true },
})

hl("SignColumn", {
  bg = "none",
})

hl("LineNr", {
  bg = "none",
})
