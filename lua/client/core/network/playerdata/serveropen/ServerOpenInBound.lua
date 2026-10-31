require "lua.client.core.network.playerData.domain.DomainsCrewMember"
require "lua.client.core.network.playerData.domain.CrewMemberSearchInfo"
require "lua.client.core.network.playerData.domain.CrewInvitation"
require "lua.client.core.network.playerData.domain.DomainCrewInBound"
require "lua.client.core.network.playerData.domain.DomainFormationInBound"
require "lua.client.core.network.playerData.domain.DomainFormationOutBound"
require "lua.client.core.network.playerData.domain.DomainContributeHeroListInBound"
require "lua.client.core.network.playerData.domain.CrewBattleChallengeOutBound"
require "lua.client.core.network.playerData.domain.DomainRecordData"
require "lua.client.core.network.event.eventOpenServer.EventServerOpenMarketItem"

--- @class ServerOpenInBound
ServerOpenInBound = Class(ServerOpenInBound)

function ServerOpenInBound:Ctor()
    --- @type number
    ---self.challengeDay = nil
    --- @type boolean
    self.hasData = nil

    --- @type number
    self.startTime = nil
    --- @type List   | QuestUnitInBound
    self.listQuest = List()

    --- @type number
    self.sizeOfListMarketItem = nil

    --- @type List   --<EventServerOpenMarketItem>
    self.listMarketItem = List()

    --- @type number
    self.sizeOfListClaim = nil

    --- @type List
    self.listClaim = List()

    --- @type Dictionary   --<id,EventServerOpenMarketItem>
    self.dictMarket = Dictionary()

    ---@type boolean
    self.hasQuestComplete = false

    ---@type boolean
    self.needRequest = false

    self.lastTimeUpdated = nil
end

function ServerOpenInBound.Validate(callback, forceUpdate)
    if forceUpdate == true or DomainInBound.IsAvailableToRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.SERVER_OPEN }, callback)
    else
        if callback then
            callback()
        end
    end
end

function ServerOpenInBound.IsAvailableToRequest()
    --- @type ServerOpenInBound
    local serverOpenInBound = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
    return serverOpenInBound.lastTimeUpdated == nil
            or (zg.timeMgr:GetServerTime() - serverOpenInBound.lastTimeUpdated) > TimeUtils.SecondAMin
            or serverOpenInBound.hasQuestComplete
end

--- @param buffer UnifiedNetwork_ByteBuf
function ServerOpenInBound:ReadBuffer(buffer)
    self.listQuest:Clear()
    self.listMarketItem:Clear()
    self.listClaim:Clear()
    self.dictMarket:Clear()

    self.hasData = buffer:GetBool()
    if self.hasData == true then
        self:ReadInnerData(buffer)
    end


    self.hasQuestComplete = false
    self.needRequest = false
end

function ServerOpenInBound:ReadInnerData(buffer)
    ---@type EventServerOpenConfig
    local serverOpenData =  self:GetConfig()
    self.numberOfDays = serverOpenData.listDay:Count()
    self.startTime = buffer:GetLong()

    self.listQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, serverOpenData.dictQuestById)

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

function ServerOpenInBound:GetConfig()
    require "lua.client.data.ServerOpen.EventServerOpenConfig"
    return ResourceMgr.GetEventServerOpenConfig() -- EventServerOpenConfig()
end

return ServerOpenInBound