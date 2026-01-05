local M = {
  win = nil,
  buf = nil,
  job = nil,
}

local function valid_win()
  return M.win and vim.api.nvim_win_is_valid(M.win)
end

local function valid_buf()
  return M.buf and vim.api.nvim_buf_is_valid(M.buf)
end

function M.open()
  if valid_win() then
    vim.api.nvim_set_current_win(M.win)
    return
  end

  vim.cmd 'botright vsplit'
  M.win = vim.api.nvim_get_current_win()

  if not valid_buf() then
    M.buf = vim.api.nvim_create_buf(false, true)

    vim.bo[M.buf].buflisted = false
    vim.bo[M.buf].swapfile = false
  end

  vim.api.nvim_win_set_buf(M.win, M.buf)

  if not M.job or vim.bo[M.buf].buftype ~= 'terminal' then
    M.job = vim.fn.jobstart({ vim.o.shell }, { term = true })

    vim.api.nvim_chan_send(M.job, 'copilot\n')

    vim.cmd 'startinsert'
  end
end

function M.hide()
  if valid_win() then
    vim.api.nvim_win_close(M.win, true)
  end

  M.win = nil
end

function M.toggle()
  if valid_win() then
    M.hide()
  else
    M.open()
  end
end

return M
