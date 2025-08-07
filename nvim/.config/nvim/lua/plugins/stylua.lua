return {
  {
    'ckipp01/stylua-nvim',
    config = function()
      if vim.fn.executable('stylua') == 0 then
        local registry = require('mason-registry')
        local pkg = registry.get_package('stylua')
        if not registry.is_installed('stylua') and not pkg:is_installing() then
          vim.notify('stylua is not installed, attempting to install via mason', vim.log.levels.INFO)
          pkg:install(nil, function(success, extra)
            local notify = vim.notify
            if vim.in_fast_event() then
              notify = vim.schedule_wrap(vim.notify)
            end
            if success then
              notify('stylua has been installed', vim.log.levels.INFO)
            else
              notify('error installing stylua', vim.log.levels.ERROR)
              notify(vim.inspect(extra), vim.log.levels.ERROR)
            end
          end)
        end
      end
    end,
  },
}
