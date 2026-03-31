---@type PluginSpec[]
return vim
  .iter({
    require('plugins.lsp.lsp'),
    require('plugins.lsp.metals'),
    require('plugins.lsp.navic'),
    require('plugins.lsp.vista'),
  })
  :flatten(1)
  :totable()
