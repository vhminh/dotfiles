---@class PluginSrc
---@field src string URI
---@field name? string name of the plugin
---@field version? string|vim.VersionRange
---@field enabled? boolean
---@see vim.pack.Spec

---@class PluginModule
---@field plugins (string|PluginSrc)[]
---@field init? fun() called before plugins are loaded (e.g. pre-load setup like autocmds)
---@field config? fun() called after plugins are loaded (e.g. plugin .setup calls)

local modules = require('plugins')

-- call .init()
for _, module in ipairs(modules) do
  if module.init then
    module.init()
  end
end

-- call vim.pack.add
---@type vim.pack.Spec[]
local plugins = {}
for _, module in ipairs(modules) do
  for _, plug in ipairs(module.plugins) do
    if type(plug) == 'string' then
      plug = { src = plug }
    end
    if plug.enabled == nil or plug.enabled then
      table.insert(plugins, { src = plug.src, version = plug.version })
    end
  end
end
vim.pack.add(plugins, { load = true, confirm = false })

-- call .config()
for _, module in ipairs(modules) do
  if module.config then
    module.config()
  end
end
