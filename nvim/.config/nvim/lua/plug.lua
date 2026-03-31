---@class PluginSpec : PluginSpecNoDeps
---@field deps? PluginSpecNoDeps[]

---@class PluginSpecNoDeps
---@field src string URI
---@field name? string name of plugin
---@field version? string|vim.VersionRange
---@field enabled? boolean
---@field init? fun() called before plugins are loaded (e.g. pre-load setup like autocmds)
---@field config? fun() called after plugins are loaded (e.g. plugin .setup calls)
---@see vim.pack.Spec

---@param plugin PluginSpecNoDeps
---@return boolean
local function is_plugin_enabled(plugin)
  return plugin.enabled == nil or plugin.enabled --[[@as boolean]]
end

---@param plugins PluginSpec[]
---@param deps_first? boolean
---@return PluginSpecNoDeps[]
local function flatten_active_plugins(plugins, deps_first)
  ---@type PluginSpecNoDeps[]
  local top_level = vim.iter(plugins):filter(is_plugin_enabled):totable()
  ---@type PluginSpecNoDeps[]
  local deps = vim
    .iter(plugins)
    :filter(is_plugin_enabled)
    :filter(function(plugin)
      return plugin.deps ~= nil
    end)
    :map(function(plugin)
      return vim.iter(plugin.deps):filter(is_plugin_enabled):totable()
    end)
    :flatten(1)
    :totable()
  if deps_first then
    return vim.iter({ deps, top_level }):flatten(1):totable()
  else
    return vim.iter({ top_level, deps }):flatten(1):totable()
  end
end

---@param plugins PluginSpec[]
local function init_plugins(plugins)
  local all = flatten_active_plugins(plugins)
  for _, plugin in ipairs(all) do
    if plugin.init then
      plugin.init()
    end
  end
end

---@param plugin PluginSpecNoDeps
---@return vim.pack.Spec
local function to_vim_pack_spec(plugin)
  return {
    src = plugin.src,
    version = plugin.version,
  }
end

---@param plugins PluginSpec[]
local function pack_add(plugins)
  local all = flatten_active_plugins(plugins)
  vim.pack.add(vim.tbl_map(to_vim_pack_spec, all), { load = true, confirm = false })
end

---@param plugins PluginSpec[]
local function config_plugins(plugins)
  local all = flatten_active_plugins(plugins, true)
  for _, plugin in ipairs(all) do
    if plugin.config then
      plugin.config()
    end
  end
end

local plugins = require('plugins')
init_plugins(plugins)
pack_add(plugins)
config_plugins(plugins)
