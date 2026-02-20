local BufferTab = require 'clowiie.utils.buffer-tab'

local M = {
  win = nil,
  buf = nil,
  job = nil,
}

function M.open()
  BufferTab.open(M, function()
    if not M.job or vim.bo[M.buf].buftype ~= 'terminal' then
      M.job = vim.fn.jobstart({ vim.o.shell }, { term = true })
      vim.cmd 'wincmd T'
      vim.cmd 'startinsert'
    end
  end)
end

function M.toggle()
  BufferTab.toggle(M, M.open)
end

return M
