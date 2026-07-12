local BufferTab = require 'clowiie.utils.buffer-tab'

local M = {
  win = nil,
  buf = nil,
  job = nil,
}

function M.open()
  BufferTab.open(M, function()
    -- Start `claude` in a terminal only the first time (or if the terminal died).
    -- On re-show the buffer + job are still alive, so we just display them again.
    if not M.job or vim.bo[M.buf].buftype ~= 'terminal' then M.job = vim.fn.jobstart({ 'claude', '/resume' }, { term = true }) end
    vim.cmd 'startinsert'
  end)
end

function M.toggle() BufferTab.toggle(M, M.open) end

return M
