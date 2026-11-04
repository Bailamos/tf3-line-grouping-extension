local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local manager_window = ug_require("::/gui/line_vehicle_mgmt/manager_window.tl") as ManagerWindow
local styleutil = ug_require("::/gui/main/styleutil.tl") as StyleUtil
local LineGroupTable = ug_require("bailando_line_overview_extension::/gui/recipies/line_group_table.recipe.tl")
  as Recipe<ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>>
local CreateLineGroupButton = ug_require(
  "bailando_line_overview_extension::/gui/recipies/create_line_group_button.recipe.tl"
) as Recipe<ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>>
local ClearLineGroupsButton = ug_require(
  "bailando_line_overview_extension::/gui/recipies/clear_line_groups_button.recipe.tl"
) as Recipe<ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>>

local ManagerContentReplacement = react.RegisterRecipe(
  "LineOverviewManagerContentReplacement",
  function(params: ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>): TreeNodeId
    return builtin.BoxLayout(
      {
        orientation = builtin.type.Orientation.Horizontal,
        children = {
          builtin.Component(
            {
              layout = builtin.BoxLayout(
                {
                  orientation = builtin.type.Orientation.Vertical,
                  children = {LineGroupTable(params), ClearLineGroupsButton()},
                }
              ),
            }
          ),
          builtin.Component(
            {
              layout = builtin.BoxLayout(
                {
                  orientation = builtin.type.Orientation.Vertical,
                  children = {
                    react.CallOriginalRecipe(manager_window.ManagerWindowContent, params),
                    CreateLineGroupButton(params),
                    builtin.Component(
                      {
                        meta = {
                          styleSheet = styleutil.makeStyle(
                            {
                              size = {0, 12},
                            }
                          ),
                        },
                      }
                    ),
                  },
                }
              ),
            }
          ),
        },
      }
    )
  end
)

local function extendOriginalLineManagerWindow(replacementApi: ReactReplacementApi)
  replacementApi.ReplaceRecipe(manager_window.ManagerWindowContent, ManagerContentReplacement)
end

return {
  doReplaceFn = extendOriginalLineManagerWindow,
}

-- builtin.BoxLayout {
--     orientation = builtin.type.Orientation.Horizontal,
--     children = {
--         -- builtin.TextInputField{
--         --     meta = {
--         --         class = "font-scale-body, search",
--         --     },
--         --     placeholderText = "Enter group name",
--         --     value = lineGroupNameTextInput:old(),
--         --     onTyping = function(text: string)
--         --         lineGroupNameTextInput:set(text)
--         --     end,
--         --     onValueChange = function(text: string)
--         --         lineGroupNameTextInput:set(text)
--         --     end,
--         -- },
--         builtin.Button{
--             meta = {
--                 class = "primary, fixed-size-button",
--             },
--             content = builtin.TextView{
--                 meta = {
--                     class = "font-scale-body",
--                 },
--                 text = "Create new group",
--             },
--             onClick = function()
--                 local current = params.toolParam.lvmFilterStateRef:get()
--             local toolParam = params.toolParam
--             -- local toolStack = toolParam.gameCtx.toolStack:get():getApi()

--                 -- debugPrint(lineGroupNameTextInput:old())
--                 -- params.toolParam.lvmFilterStateRef:set({
--                 --     category = current.category,
--                 --     search = tostring(lineGroupNameTextInput:old()),
--                 --     onlyVisible = current.onlyVisible,
--                 -- })

--                 local state = params.toolParam.lineManagerStateRef:get()
--                 local selectedLines = state.lineListEntitiesSelected
--                 local selectedLinesNames = {}

--                 for i, lineEntity in ipairs(selectedLines) do
--                     local lineName = api.engine.util.getEntityName(lineEntity.entity)
--                     selectedLinesNames[i] = lineName
--                 end

--                 api.cmd.sendCommand(
--                     api.cmd.makeScriptingSendEventCmd(
--                     "",
--                     "bailando.lineManagerExtension",
--                     "bailando.assignLineToGroup",
--                     {
--                         lines = selectedLinesNames,
--                         groupName = lineGroupNameTextInput:old()
--                     }
--                 ))
--                 -- manager_window.ManagerWindowContent.
--                 -- toolParam.lvmFilterStateRef:set({
--                 --     category = {},
--                 --     search = "Line name",
--                 --     onlyVisible = false,
--                 -- })
--                 -- toolParam.lineManagerStateRef:set({
--                 --     lineListEntitiesSelected = {},
--                 --     lineListEntitiesUnselected = {},
--                 --     depotListEntitiesSelected = {},
--                 --     depotListEntitiesUnselected = {},
--                 -- })
--                 -- toolParam.gameCtx.toolStack:get():getApi().pop(
--                 --     manager_window.ManagerTool,
--                 --     nil
--                 -- )
--                 -- toolStack.push(manager_window.ManagerTool, nil, toolParam, true)
--                 -- managerVersion:set(managerVersion:old() as integer + 1)
--                 -- react.fireEvent(nil, "closeVehicleManager", {})
--                 -- react.fireEvent(nil, "openVehicleManager", {})
--                 -- debugPrint(toolParam)
--                 -- local pushUpdate = (toolParam as table)["pushUpdate"]  as function(boolean): nil
--                 -- pushUpdate(true)
--             end,
--         },
--     }
-- },
