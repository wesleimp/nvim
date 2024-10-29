local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")

local M = {}
function M.issues()
  pickers
    .new({}, {
      prompt_title = "Credo Issues",
      finder = finders.new_oneshot_job({
        "mix",
        "credo",
        "--format",
        "flycheck",
      }, {}),
      sorter = conf.generic_sorter({}),
      previewer = false,
    })
    :find()
end

return M
