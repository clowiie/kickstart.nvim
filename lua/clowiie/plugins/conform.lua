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
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }

      if disable_filetypes[vim.bo[bufnr].filetype] then return nil end

      local ts_filetypes = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
      }

      if ts_filetypes[vim.bo[bufnr].filetype] then
        local eslint_active, oxlint_active = false, false
        for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
          if client.name == 'eslint' then eslint_active = true end
          if client.name == 'oxlint' then oxlint_active = true end
        end

        if eslint_active then
          vim.cmd 'LspEslintFixAll'
          return {
            timeout_ms = 500,
            lsp_format = 'prettier',
          }
        elseif oxlint_active then
          vim.cmd 'LspOxlintFixAll'
        end
      end

      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
  },
}
