local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin
local engine_react_util = ug_require("::/gui/main/engine_react_util.tl") as EngineReactUtil
local lineGroupsUtil = ug_require("bailando_line_overview_extension::/gui/utils/line_groups.util.tl") as LineGroupsUtil

local ToggleSelectGroup = react.RegisterRecipe(
  "ToggleSelectGroup",
  function(selectedGroupIdState: ReactStateT<integer>, groupId: integer): TreeNodeId
    local selectedGroupIdMirror = react.useMirrorState(selectedGroupIdState)

    local lineCheckbox = builtin.CheckBox(
      {
        meta = {
          tooltip = "select",
        },
        onValueChange = function(value: integer)
          if value == 1 then
            selectedGroupIdState:set(groupId)
          else
            selectedGroupIdState:set(-1)
          end
        end,
        value = selectedGroupIdMirror:old() == groupId and 1 or 0,
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

local record LineGroupRepository
  selectedGroupIdState: ReactStateT<integer>
end

local LineGroupCell = react.RegisterRecipe(
  "LineGroupCell",
  function(params: Builtin.TableCellParamT<LineGroupRepository>): TreeNodeId
    local rowKey = params.rowKey
    local group = lineGroupsUtil.getGroupNameById(rowKey)
    local userParams = params.userParam

    return builtin.BoxLayout(
      {
        orientation = builtin.type.Orientation.Horizontal,
        children = {
          ToggleSelectGroup(userParams.selectedGroupIdState, params.rowKey),
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
  function(selectedGroupIdState: ReactStateT<integer>): TreeNodeId
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
              userParam = {selectedGroupIdState = selectedGroupIdState},
            }
          ),
        },
      }
    )
  end
)

return LineGroupsTable
