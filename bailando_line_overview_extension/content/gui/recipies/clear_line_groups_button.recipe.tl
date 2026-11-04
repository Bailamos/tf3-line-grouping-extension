local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local styleutil = ug_require("::/gui/main/styleutil.tl") as StyleUtil

local ClearLineGroupsButton = react.RegisterRecipe(
  "ClearLineGroupsButton",
  function(_params: ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>): TreeNodeId
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
                        text = "Clear all lines",
                      }
                    ),
                  },
                }
              ),
              onClick = function()
                api.cmd.sendCommand(
                  api.cmd.makeScriptingSendEventCmd("", "bailando.lineManagerExtension", "bailando.clearAllGroups", {})
                )
              end,
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

return ClearLineGroupsButton
