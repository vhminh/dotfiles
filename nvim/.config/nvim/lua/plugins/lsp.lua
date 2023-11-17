local is_nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0

-- completion with lspkind
local lspkind = require('lspkind')
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_trigger_on_delete = true
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  }),
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
    })
  },
})

-- define lsp signs
vim.fn.sign_define('LspDiagnosticsSignError', {
  text = '',
  texthl = 'LspDiagnosticsSignError',
})

vim.fn.sign_define('LspDiagnosticsSignWarning', {
  text = '',
  texthl = 'LspDiagnosticsSignWarning',
})

vim.fn.sign_define('LspDiagnosticsSignInformation', {
  text = '',
  texthl = 'LspDiagnosticsSignInformation',
})

vim.fn.sign_define('LspDiagnosticsSignHint', {
  text = '',
  texthl = 'LspDiagnosticsSignHint'
})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { remap = false, silent = false, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  if client.name == 'lua_ls' and vim.fn.executable('stylua') then
    vim.keymap.set('n', '<leader>lf', require('stylua-nvim').format_file)
  else
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, bufopts)
  end
  vim.keymap.set('n', '<leader>d', require('telescope.builtin').diagnostics)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, bufopts)
  vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, bufopts)

  -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes},
      range = true,
    }
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]])
  end
end

-- install language servers
local servers = { 'lua_ls', 'rust_analyzer', 'gopls', 'clangd', 'pyright', 'nil_ls' }
if not is_nixos then
  for k, v in ipairs(servers) do
    if v == 'nil_ls' then
      table.remove(servers, k)
      break
    end
  end
  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = servers,
  }
end

-- neodev for init.lua
require('neodev').setup({})

-- server specific settings
local server_settings = {
  ['Lua'] = {
    workspace = {
      checkThirdParty = false,
    },
  },
  ['gopls'] = {
    semanticTokens = true,
  },
}

-- setup language servers
for _, server in pairs(servers) do
  local opt = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = server_settings,
  }
  require('lspconfig')[server].setup(opt)
end

-- metals
local metals_config = require('metals').bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  enableSemanticHighlighting = true,
  excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
}
metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()
metals_config.on_attach = on_attach
local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt', 'java' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
