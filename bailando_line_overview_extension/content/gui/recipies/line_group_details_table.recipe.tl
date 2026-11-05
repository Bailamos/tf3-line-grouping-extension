local react = ug_require("::/gui/main/react.lua") as React
local builtin = ug_require("::/gui/main/builtin.lua") as Builtin

local ToggleSelectLineGroupDetails = react.RegisterRecipe(
  "ToggleSelectLineGroupDetails",
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

local record LineGroupRepository
  selectedGroupIdState: ReactStateT<integer>
end

local LineGroupDetailsCell = react.RegisterRecipe(
  "LineGroupDetailsCell",
  function(params: Builtin.TableCellParamT<LineGroupRepository>): TreeNodeId
    -- local selectedGroupIdState = params.userParam.selectedGroupIdState

    -- debugPrint("SELECTED GROUP FROM line group details cell: " .. selectedGroupIdState:old())
    return builtin.BoxLayout(
      {
        orientation = builtin.type.Orientation.Horizontal,
        children = {
          ToggleSelectLineGroupDetails(),
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

local LineGroupDetailsTable = react.RegisterRecipe(
  "LineGroupDetailsTable",
  function(selectedGroupIdState: ReactStateT<integer>): TreeNodeId
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
                    recipe = LineGroupDetailsCell,
                    weight = 1.0,
                  }
                ),
              },
              rowKeys = {1, 2, 3},
              scrollPolicyVertical = builtin.type.ScrollBarPolicy.AsNeededButAlwaysReserveSpace,
              scrollPolicyHorizontal = builtin.type.ScrollBarPolicy.AlwaysOff,
              keyboardNavigation = false,
              -- userParams = {selectedGroupIdState = selectedGroupIdState},
            }
          ),
        },
      }
    )
  end
)

return LineGroupDetailsTable
