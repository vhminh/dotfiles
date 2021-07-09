set termguicolors
if (has("autocmd") && !has("gui_running"))
  augroup colors
    autocmd!
    " let s:background = { "gui": "#262626", "cterm": "235", "cterm16": "0" }
    let s:background = { "gui": "#1e1e1e", "cterm": "235", "cterm16": "0" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "bg": s:background }) "No `fg` setting
  augroup END
  augroup colorextend
    autocmd!
    let s:colors = onedark#GetColors()
    autocmd ColorScheme * call onedark#extend_highlight("Keyword", { "fg": s:colors.purple })
  augroup END
endif

colorscheme onedark

