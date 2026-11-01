local record LineGroupRepository
  lineGroups: {string: {Engine.Entity}}

  addLineToGroup: function(this: LineGroupRepository, lines: {Engine.Entity}, groupName: string): nil
end

function LineGroupRepository:new(): LineGroupRepository
  return setmetatable(
    {
      lineGroups = {},
    } as LineGroupRepository,
    {__index = LineGroupRepository}
  )
end

function LineGroupRepository:addLineToGroup(lines: {Engine.Entity}, groupName: string): nil
  self.lineGroups[groupName] = lines
end

local record AddLineToGroupPayload
  lines: {Engine.Entity}
  groupName: string
end

local function getRepository(state: GameScriptState<LineGroupRepository>): LineGroupRepository
  local repository = state:get() or LineGroupRepository:new()
  if getmetatable(repository) == nil then
    setmetatable(repository, {__index = LineGroupRepository})
  end

  return repository
end

local script: GameScript<LineGroupRepository> = {
  handleEvent = function(
    _userParams: table,
    state: GameScriptState<LineGroupRepository>,
    _eventSenderId: string,
    eventDestinationId: string,
    eventName: string,
    eventPayload: AddLineToGroupPayload
  ): any
    debugPrint("Event payload", eventPayload)
    if not state:hasEventSubscriptions() then
      state:subscribeToEvent("bailando.assignLineToGroup")
    end

    if eventDestinationId ~= "bailando.lineManagerExtension" then
      return
    end

    if eventPayload.groupName == "" or #eventPayload.lines == 0 then
      debugPrint("Group name or line not selected!")
      return
    end

    if eventName == "bailando.assignLineToGroup" then
      local lineGroupRepository = getRepository(state)

      lineGroupRepository:addLineToGroup(eventPayload.lines, eventPayload.groupName)

      state:set(lineGroupRepository)
      debugPrint(lineGroupRepository)
      return
    end
  end,
}

return script
