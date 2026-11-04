local record LineGroupRepository
  nextId: integer
  lineGroups: {integer: {string}}

  addLineToGroup: function(this: LineGroupRepository, lines: {string}): nil
end

function LineGroupRepository:new(): LineGroupRepository
  return setmetatable(
    {
      nextId = 1,
      lineGroups = {},
    } as LineGroupRepository,
    {__index = LineGroupRepository}
  )
end

function LineGroupRepository:addLineToGroup(lines: {string}): nil
  self.lineGroups[self.nextId] = lines
  self.nextId = self.nextId + 1
end

local record AddLineToGroupPayload
  lines: {string}
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
    if not state:hasEventSubscriptions() then
      state:subscribeToEvent("bailando.assignLineToGroup")
      state:subscribeToEvent("bailando.clearAllGroups")
    end

    if eventDestinationId ~= "bailando.lineManagerExtension" then
      return
    end

    if eventName == "bailando.assignLineToGroup" then
      if eventPayload.groupName == "" or #eventPayload.lines == 0 then
        debugPrint("Group name or line not selected!")
        return
      end

      local lineGroupRepository = getRepository(state)

      lineGroupRepository:addLineToGroup(eventPayload.lines)

      state:set(lineGroupRepository)
      debugPrint(lineGroupRepository)
      return
    end

    if eventName == "bailando.clearAllGroups" then
      local lineGroupRepository = getRepository(state)

      lineGroupRepository.lineGroups = {}

      state:set(lineGroupRepository)
      debugPrint(lineGroupRepository)

      return
    end

    debugPrint("Unknown event: ", eventName)
  end,
}

return script
