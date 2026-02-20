local M = {}

local function valid_win(state)
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function valid_buf(state)
  return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end

function M.open(state, callback)
  if valid_win(state) then
    vim.api.nvim_set_current_win(state.win)
    return state
  end

  vim.cmd 'botright vsplit'
  state.win = vim.api.nvim_get_current_win()

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
