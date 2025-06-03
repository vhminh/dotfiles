local M = {}

M.set_lsp_highlights = function(client, bufnr)
  -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
      range = true,
    }
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { ctermbg = 'red', fg = 'fg', bg = 'LightYellow' })
    vim.api.nvim_set_hl(0, 'LspReferenceText', { ctermbg = 'red', fg = 'fg', bg = 'LightYellow' })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { ctermbg = 'red', fg = 'fg', bg = 'LightYellow' })
    local lsp_doc_hl_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = lsp_doc_hl_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = lsp_doc_hl_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

return M
