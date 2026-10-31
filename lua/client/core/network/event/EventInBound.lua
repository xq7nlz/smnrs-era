require "lua.client.core.network.event.EventTimeType"
require "lua.client.core.network.event.EventPopupModel"
require "lua.client.core.network.event.NumberBuyData"
require "lua.client.core.network.event.EventLoginData"
require "lua.client.scene.ui.home.uiEvent.UIEventLayout"
require "lua.client.core.network.event.eventCommunity.EventCommunityInBound"
require "lua.client.scene.ui.home.uiCommunityTotal.layout.CommunityEventLayout.CommunityEventData"

--- @class EventInBound
EventInBound = Class(EventInBound)

function EventInBound:Ctor()
    --- @type Dictionary|{eventTimeType : EventTimeType, eventPopupModel : EventPopupModel}
    self.eventDict = Dictionary()
    ---@type List
    self.eventPopupList = List()
    ---@type List
    self.eventIapList = List()
    --- @type number
    self.pendingRequest = nil
    --- @type UnityEngine_Coroutine
    self.requestCoroutine = nil
    --- @type number
    self.lastTimeGetEventPopupModel = nil
    --- @type number
    self.lastTimeGetEventIapModel = nil
    ---@type List
    self.eventNewHeroList = List()

    --- @type EventCommunityInBound
    self.eventCommunityInBound = EventCommunityInBound()

    --- @type CommunityEventData
    self.communityEventData = CommunityEventData()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EventInBound:ReadBuffer(buffer)
    self.eventDict = Dictionary()
    self.eventPopupList = List()
    self.eventIapList = List()
    local size = buffer:GetByte()
    for _ = 1, size do
        local eventTimeData = EventTimeData.CreateByBuffer(buffer)
        local eventTimeType = eventTimeData.eventType
        if EventTimeType.IsActiveInGame(eventTimeType) then
            --- @type EventPopupModel
            local eventPopupModel = EventPopupModel.GetEventInstanceByType(eventTimeType)
            eventPopupModel.timeData = eventTimeData
            if EventTimeType.IsEventPurchase(eventTimeType) then
                eventPopupModel.timeData.endTime = eventPopupModel.timeData.endTime - TimeUtils.SecondAMin * 10
            end
            if EventTimeType.IsEventPopup(eventTimeType) == true then
                self.eventPopupList:Add(eventTimeType)
            elseif EventTimeType.IsEventIapShop(eventTimeType) == true then
                self.eventIapList:Add(eventTimeType)
            elseif EventTimeType.IsEventNewHero(eventTimeType) == true then
                self.eventNewHeroList:Add(eventTimeType)
            end
            self.eventDict:Add(eventTimeType, eventPopupModel)
        end
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EventInBound:ReadModelData(buffer)
    local bitMask = buffer:GetLong()
    local extendBitMask = buffer:GetLong()
    local listEventBitOn = List()
    --- @param eventTimeType EventTimeType
    --- @param eventPopupModel EventPopupModel
    for eventTimeType, eventPopupModel in pairs(self.eventDict:GetItems()) do
        local isBitmaskOn = false
        if eventTimeType < 64  then
            isBitmaskOn = BitUtils.IsOn(bitMask, eventTimeType)
        else
            isBitmaskOn = BitUtils.IsOn(extendBitMask, eventTimeType - 64)
        end
        if isBitmaskOn then
            listEventBitOn:Add(eventTimeType)
        end
    end
    listEventBitOn:SortWithMethod(EventInBound.SortListEventByType)
    for i = 1, listEventBitOn:Count() do
        local eventTimeType = listEventBitOn:Get(i)
        --- @param buffer UnifiedNetwork_ByteBuf
        local getEventData = function(buffer)
            local eventPopupModel = self:GetEvent(eventTimeType)
            eventPopupModel:ReadData(buffer)
        end
        if NetworkUtils.CheckMaskRequest(buffer, getEventData) == false then
            XDebug.Log("event_time_type error bitmask: " .. tostring(eventTimeType))
        end
    end
    self.lastTimeGetEventPopupModel = zg.timeMgr:GetServerTime()
end


--- @return number
function EventInBound:CountOpeningEventPopup()
    local openingEvent = 0
    for i = 1, self.eventPopupList:Count() do
        local eventTimeType = self.eventPopupList:Get(i)
        --- @type EventPopupModel
        local eventPopupModel = self.eventDict:Get(eventTimeType)
        if eventPopupModel ~= nil and eventPopupModel:IsOpening() then
            openingEvent = openingEvent + 1
        end
    end
    return openingEvent
end

--- @return number
function EventInBound:CountOpeningEventIap()
    local openingEvent = 0
    for i = 1, self.eventIapList:Count() do
        local eventTimeType = self.eventIapList:Get(i)
        --- @type EventPopupModel
        local eventPopupModel = self.eventDict:Get(eventTimeType)
        if eventPopupModel ~= nil and eventPopupModel:IsOpening() then
            openingEvent = openingEvent + 1
        end
    end
    return openingEvent
end

--- @return boolean
function EventInBound:IsOpeningEventPopup()
    return self:CountOpeningEventPopup() > 0
end

--- @return boolean
function EventInBound:IsOpeningEventIap()
    return self:CountOpeningEventIap() > 0
end

--- @return EventPopupModel
function EventInBound:GetEvent(eventTimeType)
    return self.eventDict:Get(eventTimeType)
end

--- @return Dictionary
function EventInBound:GetAllEvents()
    return self.eventDict
end

--- @param eventTimeType EventTimeType
function EventInBound:RemoveEventByType(eventTimeType)
    self.eventDict:RemoveByKey(eventTimeType)
end

function EventInBound:GetOpeningEventCount()
    local opening = 0
    local nearestStartEvent = nil
    local current = zg.timeMgr:GetServerTime()
    for i = 1, self.eventPopupList:Count() do
        local eventTimeType = self.eventPopupList:Get(i)
        --- @type EventTimeData
        local eventTimeData = self.eventDict:Get(eventTimeType).timeData
        local startTime = eventTimeData.startTime
        local endTime = eventTimeData.endTime
        if startTime <= current and endTime >= current then
            opening = opening + 1
        elseif startTime > current then
            if nearestStartEvent == nil or (startTime < nearestStartEvent) then
                nearestStartEvent = startTime
            end
        end
    end
    return opening, nearestStartEvent
end


function EventInBound.RequestEventDataByType(eventTimeType, callbackSuccess, callbackFailed)
    --- @type EventInBound
    local eventInBound = zg.playerData:GetEvents()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        eventInBound:ReadModelData(buffer)
    end
    local bitmask = 0
    local extendBitmask = 0
    if eventTimeType < 64 then
        bitmask = BitUtils.TurnOn(bitmask,eventTimeType)
    else
        extendBitmask = BitUtils.TurnOn(extendBitmask, eventTimeType - 64)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_DATA_GET, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask
    ,PutMethod.Long, extendBitmask),
            callbackSuccess, callbackFailed, onBufferReading, false)
end

function EventInBound:IsNeedRequestEventPopup()
    if self.lastTimeGetEventPopupModel == nil then
        return true
    end
    if self.eventDict ~= nil then
        --- @param eventPopupModel EventPopupModel
        for _, eventPopupModel in pairs(self.eventDict:GetItems()) do
            if eventPopupModel:IsAvailableToRequest() == true then
                return true
            end
        end
    end
    return false
end

function EventInBound:IsNeedRequestEventIap()
    if self.lastTimeGetEventPopupModel == nil then
        return true
    end
    if self.eventDict ~= nil then
        --- @param eventTimeType EventTimeType
        --- @param eventPopupModel EventPopupModel
        for eventTimeType, eventPopupModel in pairs(self.eventDict:GetItems()) do
            if EventTimeType.IsEventIapShop(eventTimeType) and eventPopupModel:IsAvailableToRequest() == true then
                return true
            end
        end
    end
    return false
end

function EventInBound:HasNotificationEventPopup()
    local hasNotificationCommunity = self.eventCommunityInBound:HasNotification()
    if hasNotificationCommunity == true then
        return true
    end
    if self.eventDict == nil then
        return false
    end
    for i = 1, self.eventPopupList:Count() do
        local eventTimeType = self.eventPopupList:Get(i)
        --- @type EventPopupModel
        local eventPopupModel = self.eventDict:Get(eventTimeType)
        if eventPopupModel ~= nil and eventPopupModel:HasNotification() then
            return true
        end
    end
    return false
end

function EventInBound:HasNotificationEventIap()
    if self.eventDict == nil then
        return false
    end
    for i = 1, self.eventIapList:Count() do
        local eventTimeType = self.eventIapList:Get(i)
        --- @type EventPopupModel
        local eventPopupModel = self.eventDict:Get(eventTimeType)
        if eventPopupModel ~= nil and eventPopupModel:HasNotification() then
            return true
        end
    end
    return false
end

function EventInBound.ReValidateEventData()
    local eventInBound = zg.playerData:GetEvents()
    if eventInBound ~= nil then
        eventInBound.lastTimeGetEventPopupModel = nil
    end
end


--- @param callback function
--- @param forceUpdate boolean
--- @param showWaiting boolean
--- @param hideWaiting boolean
function EventInBound.ValidateEventModel(callback, forceUpdate, showWaiting, hideWaiting)
    local returnCallback = function()
        if callback ~= nil then
            callback()
        end
    end
    --- @type EventInBound
    local eventInBound = zg.playerData:GetEvents()
    if eventInBound == nil
            or forceUpdate == true
            or eventInBound:IsNeedRequestEventPopup() == true
            or (eventInBound.lastTimeGetEventPopupModel == nil
            or (zg.timeMgr:GetServerTime() - eventInBound.lastTimeGetEventPopupModel > TimeUtils.SecondAMin)) then
        local onEventTimeUpdated = function()
            --- @type EventInBound
            eventInBound = zg.playerData:GetEvents()
            eventInBound.eventPopupList = List()
            local bitmask = 0
            local extendBitmask = 0
            --- @param eventTimeType EventTimeType
            for eventTimeType, _ in pairs(eventInBound.eventDict:GetItems()) do
                if EventTimeType.HasDataModel(eventTimeType) then
                    if eventTimeType < 64 then
                        bitmask = BitUtils.TurnOn(bitmask, eventTimeType)
                    else
                        extendBitmask = BitUtils.TurnOn(extendBitmask, eventTimeType - 64)
                    end
                    if EventTimeType.IsEventPopup(eventTimeType) then
                        eventInBound.eventPopupList:Add(eventTimeType)
                    end
                    if EventTimeType.IsEventIapShop(eventTimeType) then
                        eventInBound.eventIapList:Add(eventTimeType)
                    end
                end
            end
            local onReceived = function(result)
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    eventInBound:ReadModelData(buffer)
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, returnCallback, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.EVENT_DATA_GET, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask,PutMethod.Long, extendBitmask),
                    onReceived)
        end
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.EVENT_TIME }, onEventTimeUpdated, nil, showWaiting, hideWaiting)
    else
        returnCallback()
    end
end

--- @param x EventTimeType
--- @param y EventTimeType
function EventInBound.SortListEventByType(x, y)
    if x < y then
        return -1
    end
    return 1
end

--- @return boolean
--- @param eventTimeType EventTimeType
function EventInBound.IsEventOpening(eventTimeType, dataId)
    local eventTime = zg.playerData:GetEvents()
    if eventTime == nil then
        return false
    end
    local eventModel = eventTime:GetEvent(eventTimeType)
    if dataId == nil then
        return eventModel ~= nil and eventModel:IsOpening()
    end
    return eventModel ~= nil and eventModel:IsOpening() and (dataId == eventModel.timeData.dataId)
end


--- @return boolean
function EventInBound:IsOpeningEventNewHero()
    return self:CountOpeningEventNewHero() > 0
end

--- @return number
function EventInBound:CountOpeningEventNewHero()
    local openingEvent = 0
    for i = 1, self.eventNewHeroList:Count() do
        local eventTimeType = self.eventNewHeroList:Get(i)
        --- @type EventPopupModel
        local eventPopupModel = self.eventDict:Get(eventTimeType)
        if eventPopupModel ~= nil and eventPopupModel:IsOpening() then
            openingEvent = openingEvent + 1
        end
    end
    return openingEvent
end

function EventInBound:HasNotificationEventNewHero()
    if self.eventDict == nil then
        return false
    end
    for i = 1, self.eventNewHeroList:Count() do
        local eventTimeType = self.eventNewHeroList:Get(i)
        --- @type EventPopupModel
        local eventPopupModel = self.eventDict:Get(eventTimeType)
        if eventPopupModel ~= nil
                and eventPopupModel:IsOpening()
                and eventPopupModel:HasNotification() then
            return true
        end
    end
    return false
end