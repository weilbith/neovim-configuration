vim.api.nvim_create_user_command('UnloadLuaModules', function(arguments)
  local module_name_prefix = arguments.args
  local number_of_unloaded_modules =
    require('lua_module_reloader').unload_lua_modules_starting_with_prefix(module_name_prefix)
  print(number_of_unloaded_modules .. ' Lua modules have been unloaded')
end, {
  desc = 'unload all Lua modules starting with the given prefix',
  nargs = 1,
  bar = true,
  complete = function(arglead)
    return require('lua_module_reloader').find_loaded_modules_with_prefix(arglead)
  end,
})
