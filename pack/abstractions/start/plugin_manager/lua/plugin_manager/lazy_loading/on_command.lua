--- Parse the captured arguments of a callback function for a user command into
--- an executable command again.
--- (see `:help nvim_create_user_command()` and `:help vim.cmd()`)
---
--- @param captured_arguments vim.api.keyset.create_user_command.command_args
--- @return vim.api.keyset.cmd command
local function parse_captured_arguments_as_command(captured_arguments)
  return {
    cmd = captured_arguments.name,
    -- TODO: figure out if arguments are supported for command...
    -- range = { captured_arguments.line1, captured_arguments.line2 },
    -- count = captured_arguments.count,
    -- reg = captured_arguments.reg,
    bang = captured_arguments.bang,
    args = captured_arguments.fargs,
    -- addr = TODO (not supported?)
    -- nargs = TODO (does that make sense?)
    -- nextcmd = TODO (not supported?)
    -- magic = TODO (not supported?)
    mods = captured_arguments.smods --[[@as vim.api.keyset.cmd.mods]],
  }
end

--- Creates a handler for a specific plugin, used for a user command execution.
--- The handler will load the plugin first. Afterwards it uses the given arguments
--- to call the actual command by the plugin.
---
--- @param plugin_name string
--- @return fun(arguments: vim.api.keyset.create_user_command.command_args) execution_handler
local function create_handler_for_placeholder_command(plugin_name)
  return function(captured_arguments)
    vim.cmd.packadd(plugin_name)

    local command = parse_captured_arguments_as_command(captured_arguments)
    vim.cmd(command)
  end
end

--- Creates a callback for a specific plugin, used for a user command completion.
--- The callback will load the plugin first. Afterwards it triggers the
--- completion of the actual command.
---
--- @param plugin_name string
--- @param command_name string
--- @return fun(): string[] completion_callback
local function create_callback_for_command_completion(plugin_name, command_name)
  return function()
    vim.cmd.packadd(plugin_name)
    return vim.fn.getcompletion(command_name .. ' ', 'cmdline') -- Without the trailing space, completion does not trigger properly.
  end
end

--- Mechanism to postpone the loading of a plugin in an optional package by the
--- trigger of a command. (see `:help packages`)
---
--- This creates a placeholder command for each given command of the plugin. On
--- first call it loads the plugin that actually defines the command(s) and
--- dispatches the command call again.
--- A similar mechanism is triggered when any placeholder command is used
--- directly in the command-line and autocompletion is triggered.
---
--- Note:
--- It is expected that plugins "force" overwrite all of its commands. That
--- means they do no set the `unique` option.
---
--- @param plugin_name string
--- @param command_name_s string | string[]
local function lazy_load_plugin_on_command_s(plugin_name, command_name_s)
  local command_names = type(command_name_s) == 'string' and { command_name_s }
    or type(command_name_s) == 'table' and command_name_s
    or {}

  for _, command_name in ipairs(command_names) do
    vim.api.nvim_create_user_command(
      command_name,
      create_handler_for_placeholder_command(plugin_name),
      {
        nargs = '*',
        bang = true,
        range = true,
        complete = create_callback_for_command_completion(plugin_name, command_name),
        desc = string.format(
          'Lazy loading listener to load real %s command. The actual command description will be available on first usage.',
          command_name
        ),
      }
    )
  end
end

return lazy_load_plugin_on_command_s
