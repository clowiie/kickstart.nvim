local M = {}

-- Shared ordered stack of currently-open panels (across terminal, claude, ...).
-- Panels always append at the tail with alternating splits, based on how many
-- panels are open right now (never on a panel's previous position):
--   odd  (1st, 3rd, ...) -> new full-height column on the far right (vsplit)
--   even (2nd, 4th, ...) -> bottom half of the last-opened panel     (hsplit)
-- So showing a panel back from hide just appends it at the end again.
local stack = {}

local function valid_win(state)
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function valid_buf(state)
  return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end

-- Drop panels whose window was closed outside of M.hide (e.g. :q, bufremove),
-- so the count/tail always reflect what's actually on screen.
local function prune()
  for i = #stack, 1, -1 do
    if not valid_win(stack[i]) then
      table.remove(stack, i)
    end
  end
end

local function stack_remove(state)
  for i, s in ipairs(stack) do
    if s == state then
      table.remove(stack, i)
      break
    end
  end
end

-- Create the window for the next panel at the tail and leave it focused.
local function open_split()
  prune()
  local n = #stack

  if (n + 1) % 2 == 1 then
    -- Odd -> start a new full-height column on the far right.
    vim.cmd 'botright vsplit'
  else
    -- Even -> split the last-opened panel, new panel below it.
    vim.api.nvim_set_current_win(stack[n].win)
    vim.cmd 'belowright split'
  end
end

function M.open(state, callback)
  if valid_win(state) then
    vim.api.nvim_set_current_win(state.win)
    return state
  end

  open_split()
  state.win = vim.api.nvim_get_current_win()
  table.insert(stack, state)

  if not valid_buf(state) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].buflisted = false
    vim.bo[state.buf].swapfile = false
  end

  vim.api.nvim_win_set_buf(state.win, state.buf)

  if callback then
    callback()
  end

  return state
end

function M.hide(state)
  if valid_win(state) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  stack_remove(state)
  return state
end

function M.toggle(state, open_fn)
  if valid_win(state) then
    return M.hide(state)
  else
    if open_fn then
      open_fn()
      return state
    else
      return M.open(state)
    end
  end
end

return M
