local treesitter_ensure_installed = { 'bash', 'c', 'c_sharp', 'cmake', 'comment', 'cpp', 'css', 'cuda', 'dart', 'diff',
  'dockerfile', 'fish', 'gdscript', 'gitattributes', 'gitignore', 'go', 'godot_resource', 'gomod', 'gowork', 'graphql',
  'haskell', 'hjson', 'html', 'java', 'javascript', 'jsdoc', 'json', 'json5', 'kotlin', 'latex', 'llvm', 'lua',
  'make', 'markdown', 'markdown_inline', 'meson', 'ninja', 'nix', 'pascal', 'perl', 'php', 'phpdoc', 'proto', 'python',
  'r', 'regex', 'ruby', 'rust', 'scala', 'scss', 'sql', 'swift', 'toml', 'tsx', 'typescript', 'vala', 'vim', 'vimdoc',
  'yaml', 'zig' }

require 'nvim-treesitter.configs'.setup {
  ensure_installed = treesitter_ensure_installed,
  highlight = {
    enable = true,
    custom_captures = {
      ['package.name'] = 'TSPackageName',
    },
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
