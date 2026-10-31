--- @class EventManager
EventManager = Class(EventManager)

--- @return void
--- @param battle Battle
function EventManager:Ctor(battle)
    --- @type Battle
    self.battle = battle

    --- @type Dictionary<number, List<EventListener>>
    self.listenerDict = Dictionary()

    --- @type List
    self.eventQueue = List()
end

---------------------------------------- Manage listeners ----------------------------------------
--- @return void
--- @param eventId number
--- @param eventListener EventListener
function EventManager:AddListener(eventId, eventListener)
    ---@type EventListener
    local listeners = self.listenerDict:Get(eventId)
    if listeners == nil then
        listeners = List()
        self.listenerDict:Add(eventId, listeners)
    end

    listeners:Add(eventListener)
end

--- @return void
--- @param eventId number
--- @param eventListener EventListener
function EventManager:RemoveListener(eventId, eventListener)
    ---@type EventListener
    local listeners = self.listenerDict:Get(eventId)
    if listeners ~= nil then
        listeners:RemoveOneByReference(eventListener)
    end
end

--- @return void
function EventManager:ClearAll()
    self.listenerDict:Clear()
end

---------------------------------------- Trigger Event ----------------------------------------
--- @return void
--- @param eventId EventType
--- @param eventData table
function EventManager:TriggerEvent(eventId, eventData)
    local listeners = self.listenerDict:Get(eventId)
    if listeners ~= nil and listeners:Count() > 0 then
        local triggeredListener = List()

        --- Trigger all listeners of initiator first
        ---@param listener EventListener
        for _, listener in ipairs(listeners:GetItems()) do
            if listener.myHero == nil or listener.myHero == eventData.initiator then
                if triggeredListener:IsContainValue(listener) == false then
                    triggeredListener:Add(listener)
                    listener:Trigger(eventData)
                end
            end
        end

        ----- Trigger all listeners of target second
        ---@param listener EventListener
        for _, listener in ipairs(listeners:GetItems()) do
            if listener.myHero == nil or listener.myHero == eventData.target then
                if triggeredListener:IsContainValue(listener) == false then
                    triggeredListener:Add(listener)
                    listener:Trigger(eventData)
                end
            end
        end

        --- Trigger listeners in other heroes later, in ordered (1->6)
        listeners:Sort(self, self._CompareEventListener)
        ---@param listener EventListener
        for _, listener in ipairs(listeners:GetItems()) do
            if listener.myHero ~= nil then
                if triggeredListener:IsContainValue(listener) == false then
                    triggeredListener:Add(listener)
                    listener:Trigger(eventData)
                end
            end
        end
    end
end

--- @return void
--- @param eventId EventType
--- @param eventData table
function EventManager:AddQueuedEvent(eventId, eventData)
    local queueEvent = { ["eventId"] = eventId, ["eventData"] = eventData }
    self.eventQueue:Add(queueEvent)
end

--- @return void
function EventManager:TriggerQueuedEvent()
    while self.eventQueue:Count() > 0 do
        for _, queueEvent in ipairs(self.eventQueue:GetItems()) do
            if queueEvent.eventId == EventType.HERO_DEAD then
                ActionLogUtils.CreateDeadResult(self.battle, queueEvent.eventData)
            end

            self:TriggerEvent(queueEvent.eventId, queueEvent.eventData)
            self.eventQueue:RemoveOneByReference(queueEvent)
        end
    end
end

--- @return number
--- @param first EventListener
--- @param second EventListener
function EventManager:_CompareEventListener(first, second)
    if first.myHero == nil or second.myHero == nil then
        if first.myHero == second.myHero then
            return 0
        else
            if first.myHero == nil then
                return -1
            else
                return 1
            end
        end
    end

    --- Push Hero Abyss Nero to end of event listeners
    if first.myHero.id == HeroConstants.ABYSS_NERO_ID then
        return 1
    elseif second.myHero.id == HeroConstants.ABYSS_NERO_ID then
        return -1
    end

    if first.myHero:IsSummoner() then
        return -1
    elseif second.myHero:IsSummoner() then
        return -1
    end

    --- Prefer frontLine, follow order from 1 to 6
    local positionInfo1 = first.myHero.positionInfo
    local positionInfo2 = second.myHero.positionInfo

    if positionInfo1.isFrontLine == positionInfo2.isFrontLine then
        return positionInfo1.position - positionInfo2.position
    else
        if positionInfo1.isFrontLine then
            return -1
        else
            return 1
        end
    end
end