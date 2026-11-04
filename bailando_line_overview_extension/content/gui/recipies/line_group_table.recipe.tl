local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local engine_react_util = ug_require("::/gui/main/engine_react_util.tl") as EngineReactUtil
local lineGroupsUtil = ug_require("bailando_line_overview_extension::/gui/utils/line_groups.util.tl") as LineGroupsUtil

local LineGroupCell = react.RegisterRecipe(
  "LineGroupCell",
  function(params: Builtin.TableCellParam): TreeNodeId
    local rowKey = params.rowKey
    local group = lineGroupsUtil.getGroupById(rowKey)
    debugPrint(group)
    return builtin.BoxLayout(
      {
        children = {
          builtin.TextView(
            {
              text = group,
            }
          ),
        },
      }
    )
  end
)

local LineGroupsTable = react.RegisterRecipe(
  "LineGroupsTable",
  function(_params: ToolReactUtil.ToolWindowParamPayload<ManagerWindow.ManagerToolParam>): TreeNodeId
    local record TableState
      rowKeys: {integer}
    end

    local lineGroupTableState: ReactStateT<TableState> = engine_react_util.useStepState(
      function(): TableState
        local rowKeys = lineGroupsUtil.getGroups()

        return {
          rowKeys = rowKeys,
        }
      end
    )

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
                    recipe = LineGroupCell,
                    weight = 1.0,
                  }
                ),
              },
              rowKeys = lineGroupTableState:old().rowKeys,
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

return LineGroupsTable
