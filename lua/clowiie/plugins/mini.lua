return {
  -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    require('mini.diff').setup()

    local function diff_overlay_hl()
      local add_line, add_word = '#11280a', '#1f4413'
      local del_line, del_word = '#350907', '#4f100a'

      vim.api.nvim_set_hl(0, 'MiniDiffOverAdd', { bg = add_line })
      vim.api.nvim_set_hl(0, 'MiniDiffOverContextBuf', { bg = add_line })
      vim.api.nvim_set_hl(0, 'MiniDiffOverChangeBuf', { bg = add_word })
      vim.api.nvim_set_hl(0, 'MiniDiffOverDelete', { bg = del_line })
      vim.api.nvim_set_hl(0, 'MiniDiffOverContext', { bg = del_line })
      vim.api.nvim_set_hl(0, 'MiniDiffOverChange', { bg = del_word })

      vim.api.nvim_set_hl(0, 'MiniDiffSignAdd', { fg = '#72c560' })
      vim.api.nvim_set_hl(0, 'MiniDiffSignChange', { fg = '#c9a25e' })
      vim.api.nvim_set_hl(0, 'MiniDiffSignDelete', { fg = '#cc625e' })
    end

    diff_overlay_hl()

    vim.api.nvim_create_autocmd('ColorScheme', { callback = diff_overlay_hl })

    local mini_diff = require 'mini.diff'

    local overlay_opened = {}

    vim.keymap.set('n', '<leader>ho', function() mini_diff.toggle_overlay(0) end, { desc = 'git diff [o]verlay' })

    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      callback = function(args)
        if overlay_opened[args.buf] then return end

        vim.schedule(function()
          local data = mini_diff.get_buf_data(args.buf)

          if not data then return end

          overlay_opened[args.buf] = true

          if not data.overlay then mini_diff.toggle_overlay(args.buf) end
        end)
      end,
    })

    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
      callback = function(args)
        local data = mini_diff.get_buf_data(args.buf)

        if not data then return end

        if overlay_opened[args.buf] and data.overlay then mini_diff.toggle_overlay(args.buf) end
      end,
    })

    vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
      callback = function(args)
        local data = mini_diff.get_buf_data(args.buf)

        if not data then return end

        if not data.overlay then mini_diff.toggle_overlay(args.buf) end
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
      callback = function(args) overlay_opened[args.buf] = nil end,
    })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end

    -- ... and there is more!
    --  Check out: https://github.com/nvim-mini/mini.nvim
  end,
}
