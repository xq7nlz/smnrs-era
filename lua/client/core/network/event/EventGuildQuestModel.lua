require "lua.client.core.network.event.EventGuildQuestDonationBoardInBound"

--- @class EventGuildQuestModel : EventPopupModel
EventGuildQuestModel = Class(EventGuildQuestModel, EventPopupModel)

function EventGuildQuestModel:Ctor()
    --- @type number
    self.isInGuild = nil
    --- @type Dictionary
    self.dictUserDonate = Dictionary()
    --- @type Dictionary
    self.dictMoneyDonate = Dictionary()
    --- @type List
    self.listClaim = List()

    EventPopupModel.Ctor(self)
end

--- @param moneyType MoneyType
function EventGuildQuestModel:GetGuildDonate(moneyType)
    return self.dictMoneyDonate:Get(moneyType) or 0
end

function EventGuildQuestModel:ReadInnerData(buffer)
    self.isInGuild = buffer:GetBool()
    if self.isInGuild == true then
        local size = buffer:GetShort()
        for _ = 1, size do
            local id = buffer:GetLong()
            local eventGuildQuestDonationBoardInBound = EventGuildQuestDonationBoardInBound()
            eventGuildQuestDonationBoardInBound:ReadBuffer(buffer)
            self.dictUserDonate:Add(id, eventGuildQuestDonationBoardInBound)
        end
        self.dictMoneyDonate = EventGuildQuestModel.GetMoneyDictByBuffer(buffer)
    end
    local size = buffer:GetByte()
    for _ = 1, size do
        self.listClaim:Add(buffer:GetInt())
    end
end

--- @return void
--- @param moneyType MoneyType
--- @param quantity number
function EventGuildQuestModel:AddDonate(moneyType, quantity)
    local total = quantity
    if self.dictMoneyDonate:IsContainKey(moneyType) then
        total = total + self.dictMoneyDonate:Get(moneyType)
    end
    self.dictMoneyDonate:Add(moneyType, total)

    ---@type EventGuildQuestDonationBoardInBound
    local playerDonate = self.dictUserDonate:Get(PlayerSettingData.playerId)
    if playerDonate == nil then
        ---@type BasicInfoInBound
        local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        playerDonate = EventGuildQuestDonationBoardInBound(basicInfoInBound.name, basicInfoInBound.avatarData:GetMyPlayerAvatar(), basicInfoInBound.level)
        self.dictUserDonate:Add(PlayerSettingData.playerId, playerDonate)
    end
    playerDonate:AddDonate(moneyType, quantity)
end

---@return Dictionary
--- @param buffer UnifiedNetwork_ByteBuf
function EventGuildQuestModel.GetMoneyDictByBuffer(buffer)
    local dict = Dictionary()
    local size = buffer:GetShort()
    for i = 1, size do
        dict:Add(buffer:GetShort(), buffer:GetInt())
    end
    return dict
end