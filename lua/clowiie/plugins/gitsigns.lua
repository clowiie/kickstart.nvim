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
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', '<leader>gB', gitsigns.blame, { desc = 'Git Blame' })
      map('n', '<leader>gb', gitsigns.blame_line, { desc = 'Git Blame Line' })
    end,
  },
}
