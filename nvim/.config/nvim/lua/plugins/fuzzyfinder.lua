local telescope = require('telescope')
local get_status = require('telescope.state').get_status

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '-g',
      '!{.git,node_modules}',
    },
    dynamic_preview_title = true,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}
require('telescope').load_extension('fzf')
local telescope_builtin = require('telescope.builtin')

local get_entry_width = function()
  local status = get_status(vim.api.nvim_get_current_buf())
  return vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len() - 2
end

local intellij_style_shorten_path = function(dirs, max_len)
  if #dirs == 0 then
    return "./"
  end
  if #dirs == 1 then
    return dirs[1]
  end
  local lefts = { dirs[1] }
  local rights = { dirs[#dirs] }
  local left_end = 1
  local right_start = #dirs
  local left_len = #lefts[1]
  local right_len = #rights[1]
  while left_end + 1 < right_start do
    if #lefts < #rights then
      if left_len + right_len + #dirs[left_end + 1] + #lefts + #rights > max_len then
        break
      end
      left_len = left_len + #dirs[left_end + 1]
      table.insert(lefts, dirs[left_end + 1])
      left_end = left_end + 1
    else
      if left_len + right_len + #dirs[right_start - 1] + #lefts + #rights > max_len then
        break
      end
      right_len = right_len + #dirs[right_start - 1]
      table.insert(rights, dirs[right_start - 1])
      right_start = right_start - 1
    end
  end
  local parts = {}
  for _, v in ipairs(lefts) do
    table.insert(parts, v)
  end
  if #lefts + #rights < #dirs then
    table.insert(parts, '...')
  end
  for _, v in ipairs(rights) do
    table.insert(parts, v)
  end
  return table.concat(parts, '/')
end

local intellij_style_path_display = function(opts, filepath)
  local parents = vim.split(filepath, '/')
  local filename = table.remove(parents, #parents)
  local min_padding = 8
  local entry_width = get_entry_width()
  local remain = entry_width - #filename - min_padding
  local parent_dir = intellij_style_shorten_path(parents, remain)
  local padding = entry_width - #filename - #parent_dir
  return filename .. string.rep(' ', padding) .. parent_dir
end

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

vim.keymap.set('n', '<leader>a', telescope_builtin.builtin)
-- files and finders
vim.keymap.set('n', '<C-f>', function()
  telescope_builtin.find_files({
    path_display = intellij_style_path_display,
    find_command = { 'fd', '--type', 'file', '--hidden', '--exclude', '.git' },
  })
end)
vim.keymap.set('n', '<leader>f', function()
  telescope_builtin.find_files({
    path_display = intellij_style_path_display,
    find_command = { 'fd', '--type', 'file', '--hidden', '--exclude', '.git' },
  })
end)
vim.keymap.set('n', '<leader>b', telescope_builtin.buffers)
vim.keymap.set('n', '<leader>g', function()
  telescope_builtin.live_grep({
    path_display = { 'tail' },
  })
end)
-- lsp
vim.keymap.set('n', 'gr', telescope_builtin.lsp_references)
vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>d', telescope_builtin.diagnostics)
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations)
