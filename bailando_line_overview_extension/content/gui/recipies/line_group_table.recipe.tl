local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local engine_react_util = ug_require("::/gui/main/engine_react_util.tl") as EngineReactUtil
local lineGroupsUtil = ug_require("bailando_line_overview_extension::/gui/utils/line_groups.util.tl") as LineGroupsUtil

local ToggleSelectGroup = react.RegisterRecipe(
  "ToggleSelectGroup",
  function(): TreeNodeId
    local isSelectedState = react.useState(0)
    local lineCheckbox = builtin.CheckBox(
      {
        meta = {
          tooltip = "select",
        },
        onValueChange = function(__val: integer)
          if isSelectedState:old() == 0 then
            isSelectedState:set(1)
          else
            isSelectedState:set(0)
          end
        end,
        value = isSelectedState:old(),
      }
    )

    return builtin.FloatingLayout(
      {
        children = {
          builtin.FloatingLayoutChild(
            {
              h = -1,
              v = -1,
              item = lineCheckbox,
            }
          ),
        },
      }
    )
  end
)

local LineGroupCell = react.RegisterRecipe(
  "LineGroupCell",
  function(params: Builtin.TableCellParam): TreeNodeId
    local rowKey = params.rowKey
    local group = lineGroupsUtil.getGroupNameById(rowKey)

    return builtin.BoxLayout(
      {
        orientation = builtin.type.Orientation.Horizontal,
        children = {
          ToggleSelectGroup(),
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
