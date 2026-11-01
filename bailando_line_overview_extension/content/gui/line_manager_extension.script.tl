local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local manager_window = ug_require("::/gui/line_vehicle_mgmt/manager_window.tl") as ManagerWindow
local styleutil = ug_require("::/gui/main/styleutil.tl") as StyleUtil

local function getGroups(): {string}
  local entity = api.engine.system.gameScriptSystem.getEntityForGameScript(
    "bailando_line_overview_extension::/gui/line_groups.gs"
  )

  if not entity or entity < 0 then
    return {"empty"}
  end

  local component: Engine.Component.GameScript<table> = api.engine.getComponent(
    entity, api.type.ComponentType.GAME_SCRIPT
  )

  if not component then
    return {"empty"}
  end

  local state = component.state as {string: {string: Engine.Entity}}
  local lineGroups = state.lineGroups

  local lineGroupsNames: {string} = {}

  for groupName, _ in pairs(lineGroups) do
    lineGroupsNames[#lineGroupsNames + 1] = groupName
  end

  debugPrint("LINES", lineGroupsNames)

  return lineGroupsNames
end

local GroupSelectedLinesButtonBar = react.RegisterRecipe(
  "GroupSelectedLinesButtonBar",
  function(params: ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>): TreeNodeId
    local CreateGroupFromSelectedLines = function()
      local state = params.toolParam.lineManagerStateRef:get()
      local selectedLines = state.lineListEntitiesSelected
      local selectedLinesNames = {}

      for i, lineEntity in ipairs(selectedLines) do
        local lineName = api.engine.util.getEntityName(lineEntity.entity)
        selectedLinesNames[i] = lineName
      end

      api.cmd.sendCommand(
        api.cmd.makeScriptingSendEventCmd(
          "",
          "bailando.lineManagerExtension",
          "bailando.assignLineToGroup",
          {lines = selectedLinesNames, groupName = "TMP"}
        )
      )
    end

    return builtin.BoxLayout(
      {
        orientation = builtin.type.Orientation.Horizontal,
        children = {
          builtin.Component(
            {
              meta = {
                class = "horizontal-spacer",
              },
            }
          ),
          builtin.Button(
            {
              meta = {
                class = "primary, fixed-size-button, btn-new-line",
              },
              content = builtin.BoxLayout(
                {
                  orientation = builtin.type.Orientation.Horizontal,
                  children = {
                    builtin.ImageView(
                      {
                        path = "bailando_line_overview_extension::/gui/icons/line_group_plus.tga",
                        scaling = builtin.type.ImageViewScaling.AutoFit,
                      }
                    ),
                    builtin.TextView(
                      {
                        text = "Group selected lines",
                      }
                    ),
                  },
                }
              ),
              onClick = function() CreateGroupFromSelectedLines() end,
            }
          ),
          builtin.Component(
            {
              meta = {
                styleSheet = styleutil.makeStyle(
                  {
                    size = {12, 0},
                  }
                ),
              },
            }
          ),
        },
      }
    )
  end
)

local GroupCell = react.RegisterRecipe(
  "GroupCell",
  function(_params: Builtin.TableCellParam): TreeNodeId
    return builtin.BoxLayout(
      {
        children = {
          builtin.TextView(
            {
              text = "test",
            }
          ),
        },
      }
    )
  end
)

local GroupsOverviewSection = react.RegisterRecipe(
  "GroupsOverviewSection",
  function(_params: ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>): TreeNodeId
    return builtin.BoxLayout(
      {
        orientation = builtin.type.Orientation.Vertical,
        children = {
          builtin.DataTable(
            {
              disableSortKey = true,
              columns = {
                builtin.ColumnDesc(
                  {
                    name = "Group",
                    recipe = GroupCell,
                    weight = 1.0,
                  }
                ),
              },
              rowKeys = {1, 2, 3},
              scrollPolicyVertical = builtin.type.ScrollBarPolicy.AsNeededButAlwaysReserveSpace,
              scrollPolicyHorizontal = builtin.type.ScrollBarPolicy.AlwaysOff,
              keyboardNavigation = false,
            }
          ),
        },
      }
    )
  end
)

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
                  children = {GroupsOverviewSection(params), GroupSelectedLinesButtonBar()},
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
                    GroupSelectedLinesButtonBar(params),
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
