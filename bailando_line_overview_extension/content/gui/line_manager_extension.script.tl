local react = ug_require "::/gui/main/react.lua" as React
local builtin = ug_require "::/gui/main/builtin.lua" as Builtin
local manager_window = ug_require "::/gui/line_vehicle_mgmt/manager_window.tl" as ManagerWindow
local styleutil = ug_require "::/gui/main/styleutil.tl" as StyleUtil

local GroupCell = react.RegisterRecipe(
    "GroupCell",
    function(params: Builtin.TableCellParam): TreeNodeId
        local names = { "City buses", "Trams", "Regional trains" }

        return builtin.BoxLayout {
            child = builtin.TextView {
                text = names[params.rowKey],
            }
        }
    end
)

local ManagerContentReplacement = react.RegisterRecipe(
    "LineOverviewManagerContentReplacement",
    function(
        params: ToolReactUtil.ToolWindowParamPayload<
            ManagerWindow.ManagerToolParam
        >
    ): TreeNodeId

        local lineGroupNameTextInput = react.useState("")

        local lineGroupManagerSection = builtin.BoxLayout {
            orientation = builtin.type.Orientation.Vertical,
            children = {
                builtin.BoxLayout {
                    orientation = builtin.type.Orientation.Horizontal,
                    children = {
                        builtin.TextInputField{
                            meta = {
                                class = "font-scale-body, search",
                            },
                            placeholderText = "Enter group name",
                            value = lineGroupNameTextInput:old(),
                            onTyping = function(text: string)
                                lineGroupNameTextInput:set(text)
                            end,
                            onValueChange = function(text: string)
                                lineGroupNameTextInput:set(text)
                            end,
                        },
                        builtin.Button{
                            meta = {
                                class = "primary, fixed-size-button",
                            },
                            content = builtin.TextView{
                                meta = {
                                    class = "font-scale-body",
                                },
                                text = "Create new group",
                            },
                            onClick = function()
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
                                    {
                                        lines = selectedLinesNames,
                                        groupName = lineGroupNameTextInput:old()
                                    }
                                ))
                            end,
                        },
                    }
                },
                builtin.DataTable {
                    disableSortKey = true,
                     columns = {
                        builtin.ColumnDesc{
                            name = "Group",
                            recipe = GroupCell,
                            weight = 1.0,
                        },
                    },
                    rowKeys = {1, 2, 3},
                    scrollPolicyVertical = builtin.type.ScrollBarPolicy.AsNeededButAlwaysReserveSpace,
                    scrollPolicyHorizontal = builtin.type.ScrollBarPolicy.AlwaysOff,
                    keyboardNavigation = false,
                    meta = {
                        styleSheet = styleutil.makeStyle{
                            minSize = { -1, 300 },
                        },
                    },
                },
            }
        }

        return builtin.BoxLayout{
            children = {
                lineGroupManagerSection,
                react.CallOriginalRecipe(
                    manager_window.ManagerWindowContent,
                    params
                ),
            },
        }
    end
)

local function extendOriginalLineManagerWindow(replacementApi: ReactReplacementApi)
    replacementApi.ReplaceRecipe(
        manager_window.ManagerWindowContent,
        ManagerContentReplacement
    )
end

return {
    doReplaceFn = extendOriginalLineManagerWindow,
}