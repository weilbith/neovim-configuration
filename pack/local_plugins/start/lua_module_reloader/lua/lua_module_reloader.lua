---@param prefix string
---@return string[] module_names
local function find_loaded_modules_with_prefix(prefix)
  if prefix == '' then
    return {}
  else
    return vim
      .iter(vim.tbl_keys(package.loaded))
      :filter(function(module_name)
        return vim.startswith(module_name, prefix)
      end)
      :totable()
  end
end

---@param module_name string
---@return nil
local function unload_module(module_name)
  if package.loaded[module_name] ~= nil then
    package.loaded[module_name] = nil
  end
end

---@param prefix string
---@return integer number of unloaded modules
local function unload_lua_modules_starting_with_prefix(prefix)
  local matching_module_names = find_loaded_modules_with_prefix(prefix)
  vim.iter(matching_module_names):each(unload_module)
  return #matching_module_names
end

return {
  unload_lua_modules_starting_with_prefix = unload_lua_modules_starting_with_prefix,
  find_loaded_modules_with_prefix = find_loaded_modules_with_prefix,
}
