if not pcall(require, "plenary") then
  return
end

local log = require("plenary.log").new({
  plugin = "notify",
  use_console = false,
  level = "debug",
})

vim.notify = function(msg, level, opts)
  log.info(msg, level, opts)

  require("notify")(msg, level, opts)
end
