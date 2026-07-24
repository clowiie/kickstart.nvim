return {
  -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      javascript = { 'oxfmt', 'prettier', stop_after_first = true },
      javascriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
      typescript = { 'oxfmt', 'prettier', stop_after_first = true },
      typescriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    },
    format_on_save = function(bufnr)
      local timeout_ms = 500

      local disable_filetypes = { c = true, cpp = true }

      local filetype = vim.bo[bufnr].filetype

      if disable_filetypes[filetype] then return nil end

      local ts_filetypes = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
      }

      if not ts_filetypes[filetype] then return {
        timeout_ms = timeout_ms,
        lsp_format = 'fallback',
      } end

      local eslint_active, oxlint_active = false, false
      for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
        if client.name == 'eslint' then eslint_active = true end
        if client.name == 'oxlint' then oxlint_active = true end
      end

      if not eslint_active and oxlint_active then return {
        timeout_ms = timeout_ms,
        lsp_format = 'fallback',
      } end

      if eslint_active then
        return {
          timeout_ms = timeout_ms,
          formatters = { 'prettier' },
        }
      elseif oxlint_active then
        return {
          timeout_ms = timeout_ms,
          formatters = { 'oxfmt' },
        }
      end
    end,
  },
}
