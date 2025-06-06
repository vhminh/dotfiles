return {
  {
    'navarasu/onedark.nvim',
    opts = {
      style = 'warmer',
      code_style = {
        comments = 'none',
      },
      highlights = {
        ['NvimTreeFolderIcon'] = { fg = '$blue' },

        ['TelescopeBorder'] = { fg = '$fg' },
        ['TelescopePromptBorder'] = { fg = '$fg' },
        ['TelescopePreviewBorder'] = { fg = '$fg' },
        ['TelescopeResultsBorder'] = { fg = '$fg' },

        ['GitGutterChange'] = { fg = '$yellow' },
        ['GitSignsChange'] = { fg = '$yellow' },
        ['GitSignsChangeLn'] = { fg = '$yellow' },
        ['GitSignsChangeNr'] = { fg = '$yellow' },

        ['WinBar'] = { fg = '$fg', bg = '$bg0' },
        ['WinBarNC'] = { fg = '$fg', bg = '$bg0' },

        ['Structure'] = { fg = '$purple' },
        ['Type'] = { fg = '$fg' },
        ['@type'] = { fg = '$fg' },
        ['@type.qualifier'] = { fg = '$purple' },
        ['@lsp.type'] = { fg = '$fg' },
        ['@lsp.type.class'] = { fg = '$fg' },
        ['@lsp.type.enum'] = { fg = '$fg' },
        ['@lsp.type.interface'] = { fg = '$fg' },
        ['@lsp.type.namespace'] = { fg = '$fg' },
        ['@lsp.type.struct'] = { fg = '$fg' },
        ['@lsp.type.type'] = { fg = '$fg' },
        ['@lsp.type.modifier'] = { fg = '$purple' },
        ['@lsp.type.string'] = { fg = '$green' },
        ['@type.builtin'] = { fg = '$purple' },

        ['Identifier'] = { fg = '$fg' },
        ['@lsp.type.parameter'] = { fg = '$fg' },
        ['@property'] = { fg = '$fg' },
        ['@lsp.type.property'] = { fg = '$fg' },
        ['@variable'] = { fg = '$fg' },
        ['@variable.member'] = { fg = '$fg' },
        ['@variable.parameter'] = { fg = '$fg' },
        ['@variable.builtin'] = { fg = '$fg' },
        ['@lsp.typemod.variable.defaultLibrary'] = { fg = '$fg' },

        ['@constructor'] = { fg = '$fg', fmt = 'none' },
      },
    },
    config = function(_, opts)
      require('onedark').setup(opts)
      vim.cmd.colorscheme('onedark')
    end,
  },
}
