local ensure_installed = {
  'bash',
  'c',
  'c_sharp',
  'cmake',
  'comment',
  'cpp',
  'css',
  'cuda',
  'dart',
  'diff',
  'dockerfile',
  'fish',
  'gdscript',
  'gitattributes',
  'gitignore',
  'glsl',
  'go',
  'godot_resource',
  'gomod',
  'gowork',
  'graphql',
  'haskell',
  'hjson',
  'html',
  'java',
  'javascript',
  'jsdoc',
  'json',
  'json5',
  'kotlin',
  'latex',
  'llvm',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'meson',
  'ninja',
  'nix',
  'pascal',
  'perl',
  'php',
  'phpdoc',
  'proto',
  'python',
  'r',
  'regex',
  'ruby',
  'rust',
  'scala',
  'scss',
  'sql',
  'swift',
  'toml',
  'tsx',
  'typescript',
  'vala',
  'vim',
  'vimdoc',
  'yaml',
  'zig',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
      require('nvim-treesitter').install(ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_setup', { clear = true }),
        callback = function()
          local parser_available = vim.treesitter.get_parser(0, nil, { error = false }) ~= nil
          if parser_available then
            vim.treesitter.start() -- enable TS highlighting
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
}
