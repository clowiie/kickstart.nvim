return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    keys = {
      { '<leader>Ac', ':CopilotChat<CR>', mode = 'n', desc = 'Open AI Chat' },
      { '<leader>Ae', ':CopilotChatExplain<CR>', mode = 'v', desc = 'Explain Code' },
      { '<leader>Ar', ':CopilotChatReview<CR>', mode = 'v', desc = 'Review Code' },
      { '<leader>Af', ':CopilotChatFix<CR>', mode = 'v', desc = 'Fix Code' },
      { '<leader>Ao', ':CopilotChatOptimize<CR>', mode = 'v', desc = 'Optimize Code' },
      { '<leader>Ad', ':CopilotChatDocs<CR>', mode = 'v', desc = 'Generate Docs' },
      { '<leader>At', ':CopilotChatTests<CR>', mode = 'v', desc = 'Generate Tests' },
      { '<leader>Aa', ':CopilotChatToggle<CR>', mode = 'n', desc = 'Toggle Chat' },
      { '<leader>Ax', ':CopilotChatReset<CR>', mode = 'n', desc = 'Reset Chat' },
      { '<leader>Aq', ':CopilotChatStop<CR>', mode = 'n', desc = 'Stop Generation' },
      { '<leader>Ap', ':CopilotChatPrompts<CR>', mode = 'n', desc = 'Select AI prompts' },
      { '<leader>Am', ':CopilotChatModels<CR>', mode = 'n', desc = 'Select AI models' },
    },
    opts = {
      on_attach = function()
        local copilotChat = require 'CopilotChat'

        -- vim.g.copilot_no_tab_map = true
        -- vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

        -- Auto-command to customize chat buffer behavior
        vim.api.nvim_create_autocmd('BufEnter', {
          pattern = 'copilot-*',
          callback = function() end,
        })
      end,

      window = {
        title = '🤖 AI Assistant',
      },

      headers = {
        user = '👤 You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
      },

      separator = '━━',
      auto_fold = true, -- Automatically folds non-assistant messages
    },
  },
}
