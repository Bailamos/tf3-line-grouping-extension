local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local styleutil = ug_require("::/gui/main/styleutil.tl") as StyleUtil

local CreateLineGroupButton = react.RegisterRecipe(
  "CreateLineGroupButton",
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
      -- local toolParam = params.toolParam
      -- toolParam.lineManagerStateRef:set(
      --   {
      --     lineListEntitiesSelected = {},
      --     lineListEntitiesUnselected = {},
      --     depotListEntitiesSelected = {},
      --     depotListEntitiesUnselected = {},
      --   }
      -- )
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

return CreateLineGroupButton
