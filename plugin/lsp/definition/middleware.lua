--- @param location table<string, any> - Location object according to LSP
--- @return boolean
local function location_points_to_react_type_definitions(location)
  local uri = location.targetUri or location.uri or ''
  return vim.endswith(uri, 'react/index.d.ts')
    or vim.endswith(uri, 'react-redux.d.ts')
    or vim.endswith(uri, 'react-scripts/lib/react-app.d.ts')
end

--- @param result table? - according to LSP response object
local function result_matches_scenario_of_react_component_definition_result(result)
  result = result or {}

  local has_scenario_specific_number_of_entries = #result == 2
  local any_entry_points_to_react_type_definition =
    vim.iter(result):any(location_points_to_react_type_definitions)

  return has_scenario_specific_number_of_entries and any_entry_points_to_react_type_definition
end

--- When trying to get the definition of a React component used in a JSX
--- template, the language server does not respond precisely. Instead it
--- returns a list of two definitions. One of them points to the React type
--- definition of a ReadNode in the dependencies.
--- This is very annoying. Identifying this scenario and filtering that
--- unwanted second response entry helps to jump (preview, ...) directly to
--- the intended location.
--- There are more cases like with the Redux library too.
---
--- @param result table - according to LSP response object
--- @return table result but potentially filtered
local function filter_results_to_react_node_type(result)
  if result_matches_scenario_of_react_component_definition_result(result) then
    return vim
      .iter(result)
      :filter(function(location)
        return not location_points_to_react_type_definitions(location)
      end)
      :totable()
  else
    return result
  end
end

require('lsp.start.middleware').register_handler(
  vim.lsp.protocol.Methods.textDocument_definition,
  function(error, result, context, configuration)
    result = filter_results_to_react_node_type(result)
    return true, error, result, context, configuration
  end,
  100,
  'typescriptreact'
)
