local function setup_mode_highlights()
  local function get_fg(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    return hl.fg
  end

  local sl_bg = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false }).bg
  local sl_bg_nc =
    vim.api.nvim_get_hl(0, { name = "StatusLineNC", link = false }).bg

  -- Active mode highlights (fg from colorscheme, bg from StatusLine)
  vim.api.nvim_set_hl(
    0,
    "ElNormalMode",
    { fg = sl_bg, bg = get_fg("Function"), bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    "ElInsertMode",
    { fg = sl_bg, bg = get_fg("String"), bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    "ElVisualMode",
    { fg = sl_bg, bg = get_fg("Type"), bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    "ElCommandMode",
    { fg = sl_bg, bg = get_fg("Constant"), bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    "ElReplaceMode",
    { fg = sl_bg, bg = get_fg("DiagnosticError"), bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    "ElOtherMode",
    { fg = sl_bg, bg = get_fg("Special"), bold = true }
  )

  -- Inactive variants (muted, using StatusLineNC bg)
  vim.api.nvim_set_hl(
    0,
    "ElNormalModeInactive",
    { fg = get_fg("Comment"), bg = sl_bg_nc }
  )
  vim.api.nvim_set_hl(
    0,
    "ElInsertModeInactive",
    { fg = get_fg("Comment"), bg = sl_bg_nc }
  )
  vim.api.nvim_set_hl(
    0,
    "ElVisualModeInactive",
    { fg = get_fg("Comment"), bg = sl_bg_nc }
  )
  vim.api.nvim_set_hl(
    0,
    "ElCommandModeInactive",
    { fg = get_fg("Comment"), bg = sl_bg_nc }
  )
  vim.api.nvim_set_hl(
    0,
    "ElReplaceModeInactive",
    { fg = get_fg("Comment"), bg = sl_bg_nc }
  )
  vim.api.nvim_set_hl(
    0,
    "ElOtherModeInactive",
    { fg = get_fg("Comment"), bg = sl_bg_nc }
  )
end

setup_mode_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_mode_highlights,
})

-- Statusline
local mode_map = {
  n = { "NORMAL", "ElNormalMode" },
  i = { "INSERT", "ElInsertMode" },
  v = { "VISUAL", "ElVisualMode" },
  V = { "V-LINE", "ElVisualMode" },
  ["\22"] = { "V-BLOC", "ElVisualMode" },
  c = { "COMMND", "ElCommandMode" },
  R = { "REPLCE", "ElReplaceMode" },
  t = { "TERMNL", "ElOtherMode" },
}
function StatusLine()
  local m = vim.api.nvim_get_mode().mode
  local is_active = vim.api.nvim_get_current_win()
    == tonumber(vim.g.statusline_winid)
  local info = mode_map[m] or { m, "ElOtherMode" }
  local mode_str = info[1]
  local mode_hl = is_active and info[2] or (info[2] .. "Inactive")
  -- local rel_path = vim.fn.expand("%:~:.")
  local rel_path = vim.fn.expand("%:~:.")
  if rel_path == "" then
    rel_path = "[No Name]"
  end
  local ft = vim.bo.filetype

  -- git (branch + diff)
  local git_str = ""
  local git = vim.b.gitsigns_status_dict
  if git then
    local branch = git.head and (" " .. git.head) or ""
    local added = git.added and git.added > 0 and ("+" .. git.added) or ""
    local changed = git.changed and git.changed > 0 and ("~" .. git.changed)
      or ""
    local removed = git.removed and git.removed > 0 and ("-" .. git.removed)
      or ""
    local diff_parts = {}
    if added ~= "" then
      table.insert(diff_parts, "%#GitSignsAdd#" .. added .. "%*")
    end
    if changed ~= "" then
      table.insert(diff_parts, "%#GitSignsChange#" .. changed .. "%*")
    end
    if removed ~= "" then
      table.insert(diff_parts, "%#GitSignsDelete#" .. removed .. "%*")
    end
    local diff_str = #diff_parts > 0
        and (" [" .. table.concat(diff_parts, " ") .. "]")
      or ""
    if branch ~= "" then
      git_str = branch .. diff_str .. " "
    end
  end

  -- diagnostics
  local diag_str = ""
  local count = vim.diagnostic.count(0)
  local e = count[vim.diagnostic.severity.ERROR] or 0
  local w = count[vim.diagnostic.severity.WARN] or 0
  local h = count[vim.diagnostic.severity.HINT] or 0
  local i = count[vim.diagnostic.severity.INFO] or 0
  local parts = {}
  if e > 0 then
    table.insert(parts, "%#DiagnosticError#E:" .. e .. "%*")
  end
  if w > 0 then
    table.insert(parts, "%#DiagnosticWarn#W:" .. w .. "%*")
  end
  if h > 0 then
    table.insert(parts, "%#DiagnosticHint#H:" .. h .. "%*")
  end
  if i > 0 then
    table.insert(parts, "%#DiagnosticInfo#I:" .. i .. "%*")
  end
  if #parts > 0 then
    diag_str = "(" .. table.concat(parts, ", ") .. ")     "
  end

  local tail = vim.fn.fnamemodify(rel_path, ":t")
  local ext = vim.fn.fnamemodify(rel_path, ":e")

  local icon_str = ""

  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    local icon, hl_name = devicons.get_icon(tail, ext, { default = true })
    local _, hex_color = devicons.get_icon_color(tail, ext, { default = true })

    if icon and hex_color then
      local hl_group = "LualineDevicon_" .. (hl_name or "default")

      local lualine_hl =
        vim.api.nvim_get_hl(0, { name = "lualine_c_normal", link = false })
      local bg = lualine_hl.bg

      vim.api.nvim_set_hl(0, hl_group, { fg = hex_color, bg = bg })

      icon_str = "%#" .. hl_group .. "#" .. icon .. "%*"
    end
  end

  local ok, icon = pcall(function()
    return require("nvim-web-devicons").get_icon(".gitattributes")
  end)
  local git_icon = ok and icon or ""

  return "%#"
    .. mode_hl
    .. "#["
    .. mode_str
    .. "]%* "
    .. git_icon
    .. git_str
    .. "%="
    .. icon_str
    .. " "
    .. rel_path
    .. "%m%r%="
    .. diag_str
    .. "%P [%l : %c]"
    .. (ft ~= "" and "[" .. ft .. "]" or "")
end

vim.o.statusline = "%!v:lua.StatusLine()"
