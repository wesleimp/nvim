local function _map(mode)
  return function(lhs, rhs, opt)
    vim.keymap.set(mode, lhs, rhs, opt or {})
  end
end

local map = _map("")
local nmap = _map("n")
local vmap = _map("v")
local imap = _map("i")
local omap = _map("o")
local tmap = _map("t")

-- map <space> <leader>
vim.g.mapleader = " "

--disable help
nmap("<F1>", "")
imap("<F1>", "")

nmap("Y", "yg$", { noremap = true, desc = "Yank to end of line" })
nmap("n", "nzzzv", { noremap = true, desc = "Next search result centered" })
nmap("N", "Nzzzv", { noremap = true, desc = "Previous search result centered" })

nmap("<leader><leader>r", "<cmd>source %<CR>")

nmap("<leader>cn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
nmap("<leader>cp", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
nmap(
  "<leader>cc",
  ":copen<cr>",
  { noremap = true, silent = true, desc = "Open quickfix list" }
)

-- line selection without indentation
nmap("vv", "^vg_", { noremap = true, desc = "Select line without indentation" })

--remap :W, :Q etc if you press the shift key for too long
vim.cmd([[
cabbrev Q quit
cabbrev W write
cabbrev WQ wq
cabbrev Wq wq
cabbrev QA qa
cabbrev Qa qa
]])

--Register copy/paster
map(
  "<leader>y",
  '"+y<esc>',
  { noremap = true, desc = "Yank to system clipboard" }
)
map(
  "<leader>p",
  '"+p<esc>',
  { noremap = true, desc = "Paste from system clipboard" }
)

--No highlight after search
nmap(
  "<leader><CR>",
  ":noh<CR>",
  { noremap = true, silent = true, desc = "No highlight" }
)

--------------------------------------------------
--Buffer
--------------------------------------------------
-- Pane switching
map("<C-j>", "<C-W>j")
map("<C-k>", "<C-W>k")
map("<C-h>", "<C-W>h")
map("<C-l>", "<C-W>l")

map("<left>", "gT")
map("<right>", "gt")

-- These mappings control the size of splits (height/width)
map("<M-,>", "<c-w>5<")
map("<M-.>", "<c-w>5>")
map("<M-t>", "<C-W>+")
map("<M-s>", "<C-W>-")
--------------------------------------------------
-- vim-test
--------------------------------------------------
nmap(
  "<Leader>tt",
  ":w|:TestSuite<CR>",
  { silent = true, desc = "Run test suite" }
)
nmap(
  "<Leader>tf",
  ":w|:TestFile<CR>",
  { silent = true, desc = "Run test file" }
)
nmap(
  "<Leader>tn",
  ":w|:TestNearest<CR>",
  { silent = true, desc = "Run nearest test" }
)
nmap(
  "<Leader>tl",
  ":w|:TestLast<CR>",
  { silent = true, desc = "Run last test" }
)

--------------------------------------------------
-- Telescope
--------------------------------------------------
nmap(
  "<C-p>",
  ":lua require('telescope.builtin').find_files()<cr>",
  { noremap = true, silent = true, desc = "Find files" }
)
nmap(
  "<C-f>",
  ":lua require('telescope.builtin').live_grep({ hidden = true })<cr>",
  { noremap = true, silent = true, desc = "Live grep" }
)
nmap(
  "<leader>fd",
  ":lua require('telescope.builtin').grep_string({search = vim.fn.expand('<cword>')})<CR>",
  { noremap = true, silent = true, desc = "Grep current word" }
)

nmap(
  "<leader>ht",
  ":lua require('telescope.builtin').help_tags()<CR>",
  { noremap = true, silent = true, desc = "Help tags" }
)

nmap(
  "<leader>di",
  ":lua require('telescope.builtin').diagnostics()<CR>",
  { noremap = true, silent = true, desc = "Diagnostics" }
)

nmap(
  "<leader>ls",
  ":lua require('telescope.builtin').lsp_document_symbols()<CR>",
  { noremap = true, silent = true, desc = "LSP Document Symbols" }
)

nmap(
  "<leader>li",
  ":lua require('telescope.builtin').lsp_implementations()<CR>",
  { noremap = true, silent = true, desc = "LSP Implementations" }
)

nmap(
  "<leader>ld",
  ":lua require('telescope.builtin').lsp_definitions()<CR>",
  { noremap = true, silent = true, desc = "LSP Definitions" }
)

nmap(
  "<leader>lr",
  ":lua require('telescope.builtin').lsp_references()<CR>",
  { noremap = true, silent = true, desc = "LSP References" }
)

map("<f11>", ":lua require('plugins.telescope').search_nvimconf()<cr>")
map("<f12>", ":lua require('plugins.telescope').search_dotfiles()<cr>")

--------------------------------------------------
-- Focusing
--------------------------------------------------
nmap(
  "<F3>",
  ":ZenMode<CR>",
  { noremap = true, silent = true, desc = "Zen Mode" }
)
nmap(
  "<F4>",
  ":Twilight<CR>",
  { noremap = true, silent = true, desc = "Twilight" }
)

--------------------------------------------------
-- Misc
--------------------------------------------------
-- Terminal
-- tmap("<Esc>", "<C-\\><C-N>", { noremap = true, silent = true })

-- Exports
local M = {
  map = map,
  nmap = nmap,
  imap = imap,
  vmap = vmap,
  omap = omap,
  tmap = tmap,
}

return M
