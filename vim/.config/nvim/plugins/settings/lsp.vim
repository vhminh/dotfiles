"" Lsp
"lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}
"lua require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
"lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
"lua require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}
"
"" Key bindings
"" nnoremap <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap K     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"" nnoremap gd    <cmd>lua vim.lsp.buf.declaration()<CR>
"nnoremap gd    <cmd>lua vim.lsp.buf.definition()<CR>
"
"nnoremap <C-LeftMouse> <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <leader>lc    <cmd>lua vim.lsp.buf.code_action()<CR>
"nnoremap <leader>lf    <cmd>lua vim.lsp.buf.formatting()<CR>
"nnoremap <leader>lr    <cmd>lua vim.lsp.buf.rename()<CR>

lua require('lsp')

