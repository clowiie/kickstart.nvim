return {
  -- See `:help gitsigns` to understand what the configuration keys do
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  -- opts = {
  --   -- signs = {
  --   --   add = { text = '+' },
  --   --   change = { text = '~' },
  --   --   delete = { text = '_' },
  --   --   topdelete = { text = '‾' },
  --   --   changedelete = { text = '~' },
  --   -- },
  -- },
  config = function()
    local gitsigns = require 'gitsigns'

    gitsigns.setup {}

    vim.keymap.set('n', '<leader>gB', '<cmd>lua require("gitsigns").blame()<CR>', { desc = 'Git Blame' })
    vim.keymap.set('n', '<leader>gb', '<cmd>lua require("gitsigns").blame_line()<CR>', { desc = 'Git Blame Line' })
  end,
}
