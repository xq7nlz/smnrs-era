require "lua.client.core.network.event.eventOpenServer.EventServerOpenMarketItem"

--- @class EventOpenServerInbound : EventPopupModel
EventOpenServerInbound = Class(EventOpenServerInbound, EventPopupModel)

function EventOpenServerInbound:Ctor()
    EventPopupModel.Ctor(self)
    --- @type List   | QuestUnitInBound
    self.listQuest = List()
    --- @type List   --<EventServerOpenMarketItem>
    self.listMarketItem = List()
    --- @type List
    self.listClaim = List()
    --- @type Dictionary  --<id,QuestUnitInBound>
    self.dictQuest = Dictionary()
    --- @type Dictionary   --<id,EventServerOpenMarketItem>
    self.dictMarket = Dictionary()

    ---@type boolean
    self.hasQuestComplete = false

    ---@type boolean
    self.needRequest = false

    RxMgr.serverNotification:Filter(function(data)
        return BitUtils.IsOn(data, ServerNotificationType.EVENT_UPDATED)
    end) :Subscribe(function()
        --XDebug.Log("ServerNotificationType.EVENT_UPDATED")
        self.needRequest = true
    end)

    RxMgr.serverNotification:Filter(function(data)
        return BitUtils.IsOn(data, ServerNotificationType.EVENT_COMPLETED)
    end) :Subscribe(function()
        --XDebug.Log("ServerNotificationType.EVENT_COMPLETED")
        self.hasQuestComplete = true
        self.needRequest = true
    end)
    --XDebug.Log("RxMgr.serverNotification:Subscribe")
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventOpenServerInbound:ReadData(buffer)
    self.listQuest:Clear()
    self.listMarketItem:Clear()
    self.listClaim:Clear()
    self.dictQuest:Clear()
    self.dictMarket:Clear()

    self.hasData = buffer:GetBool()
    if self.hasData == true then
        self:ReadInnerData(buffer)
    end
    self.hasQuestComplete = false
    self.needRequest = false
end

function EventOpenServerInbound:ReadInnerData(buffer)
    ---@type ServerOpenData
    local serverOpenData = self:GetConfig()
    self.listQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, serverOpenData.dictQuestById)
    for i = 1, self.listQuest:Count() do
        ---@type QuestUnitInBound
        local questUnitInBound = self.listQuest:Get(i)
        self.dictQuest:Add(questUnitInBound.questId, questUnitInBound)
    end

    local size = buffer:GetShort()
    for _ = 1, size do
        local item = EventServerOpenMarketItem.CreateBuffer(buffer, serverOpenData.dictMarketById)
        self.listMarketItem:Add(item)
        self.dictMarket:Add(item.id, item)
    end
    size = buffer:GetByte()
    for _ = 1, size do
        self.listClaim:Add(buffer:GetInt())
    end
    self.listQuest:SortWithMethod(QuestUnitInBound.SortById)
end

---@type ServerOpenData
function EventOpenServerInbound:GetConfig()
    return EventPopupModel.GetConfig(self)
end

return EventOpenServerInbound