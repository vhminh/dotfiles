---@type PluginModule[]
return vim
  .iter({
    { require('plugins.autopairs') },
    { require('plugins.cmp') },
    { require('plugins.comment') },
    { require('plugins.filetree') },
    { require('plugins.fuzzyfinder') },
    { require('plugins.git') },
    { require('plugins.indent') },
    { require('plugins.leap') },
    require('plugins.lsp'),
    { require('plugins.stylua') },
    { require('plugins.theme') },
    { require('plugins.treesitter') },
  })
  :flatten(1)
  :totable()
