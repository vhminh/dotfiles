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

local get_entry_width = function()
  local status = get_status(vim.api.nvim_get_current_buf())
  return vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len()
end

local reverse = function(list)
  local result = {}
  for i = #list, 1, -1 do
    result[#result + 1] = list[i]
  end
  return result
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
  rights = reverse(rights)
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

local intellij_style_path_display = function(prefix_size)
  ---@diagnostic disable-next-line: unused-local
  return function(opts, filepath)
    local parents = vim.split(filepath, '/')
    local filename = table.remove(parents, #parents)
    local min_padding = 8
    local entry_width = get_entry_width()
    local remain = entry_width - prefix_size - #filename - min_padding
    local parent_dir = intellij_style_shorten_path(parents, remain)
    local padding = entry_width - prefix_size - #filename - #parent_dir
    return filename .. string.rep(' ', padding) .. parent_dir
  end
end

vim.cmd 'autocmd User TelescopePreviewerLoaded setlocal number'

local telescope_builtin = require('telescope.builtin')
local pickers = require('better-telescope-builtins')

vim.keymap.set('n', '<leader>a', telescope_builtin.builtin)
vim.keymap.set('n', '<C-f>', pickers.find_files)
vim.keymap.set('n', '<leader>f', pickers.find_files)
vim.keymap.set('n', '<leader>b', function()
  telescope_builtin.buffers({
    path_display = intellij_style_path_display(9), -- 7 for file status and 2 for devicon
  })
end)
vim.keymap.set('n', '<leader>g', function()
  telescope_builtin.live_grep({
    path_display = { 'tail' },
  })
end)

vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations)
