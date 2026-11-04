local function getLineGroups(): {integer: {string}}
  local entity = api.engine.system.gameScriptSystem.getEntityForGameScript(
    "bailando_line_overview_extension::/gui/line_groups.gs"
  )

  if not entity or entity < 0 then
    return {}
  end

  local component: Engine.Component.GameScript<table> = api.engine.getComponent(
    entity, api.type.ComponentType.GAME_SCRIPT
  )

  if not component then
    return {}
  end

  local state = component.state as {string: {integer: {string}}}
  local lineGroups = state.lineGroups

  return lineGroups
end

local function getGroups(): {integer}
  local lineGroups = getLineGroups()
  local lineGroupsIds: {integer} = {}

  for id, _ in pairs(lineGroups) do
    lineGroupsIds[#lineGroupsIds + 1] = id
  end

  return lineGroupsIds
end

local function getGroupById(searchedId: integer): string
  local lineGroups = getLineGroups()

  if lineGroups[searchedId] then
    return table.concat(lineGroups[searchedId], ",")
  end

  return ""
end

return {getGroups = getGroups, getGroupById = getGroupById}
