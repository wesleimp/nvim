local M = {}

local command = vim.api.nvim_create_user_command

local DEFAULT_BREAK = 5
local DEFAULT_TIMER = 25
local status = { DONE = 0, RUNNING = 1 }

local state = {
  start = 0,
  time = 0,
  status = status.DONE,
}

local function merge(lhs, rhs)
  return vim.tbl_deep_extend("force", lhs, rhs)
end

local function args_or_default(args, default)
  if args == "" then
    return default
  end

  return args
end

local DEFAULT_OPTIONS = {
  break_time = DEFAULT_BREAK,
  work_time = DEFAULT_TIMER,
  icon = "",
  time_format = "!%0M:%0S",
  messages = {
    work_complete = "Time is up. Take a brak!",
    break_complete = "Time is up. Let's work!",
  },
}

local function time_remaining_seconds(duration, start)
  return duration * 60 - os.difftime(os.time(), start)
end

local function time_remaining(duration, start)
  return os.date(
    vim.g.pomodoro.time_format,
    time_remaining_seconds(duration, start)
  )
end

local function is_work_time(duration)
  return duration == vim.g.pomodoro.work_time
end

local function start(time)
  state = merge(state, {
    start = os.time(),
    time = time,
    status = status.RUNNING,
  })
end

function M.setup(opts)
  opts = opts or {}
  local options = merge(DEFAULT_OPTIONS, opts)
  vim.g.pomodoro = options
end

function M.status()
  local status_str = ""
  if state.status == status.RUNNING then
    if time_remaining_seconds(state.time, state.start) <= 0 then
      status_str = vim.g.pomodoro.messages.work_complete
      if is_work_time(state.time) then
        status_str = vim.g.pomodoro.messages.break_complete
      end
    else
      status_str = vim.g.pomodoro.icon
        .. " "
        .. time_remaining(state.time, state.start)
    end
  end

  return status_str
end

function M.stop()
  state = merge(state, { status = status.DONE })
end

command("PomodoroStart", function(opts)
  local time = args_or_default(opts.args, vim.g.pomodoro.work_time)
  start(time)
end, { nargs = "?" })

command("PomodoroBreak", function(opts)
  local time = args_or_default(opts.args, vim.g.pomodoro.break_time)
  start(time)
end, { nargs = "?" })

command("PomodoroStop", function()
  M.stop()
end, {})

command("PomodoroStatus", function()
  print(M.status())
end, {})

return M
