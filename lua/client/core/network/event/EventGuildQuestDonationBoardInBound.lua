--- @class EventGuildQuestDonationBoardInBound
EventGuildQuestDonationBoardInBound = Class(EventGuildQuestDonationBoardInBound)

--- @return void
function EventGuildQuestDonationBoardInBound:Ctor(playerName, playerAvatar, playerLevel)
    ---@type Dictionary
    self.moneyDict = Dictionary()
    self.playerName = playerName
    self.playerAvatar = playerAvatar
    self.playerLevel = playerLevel
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EventGuildQuestDonationBoardInBound:ReadBuffer(buffer)
    local size = buffer:GetShort()
    ---@type Dictionary
    self.moneyDict:Clear()
    for i = 1, size do
        self.moneyDict:Add(buffer:GetShort(), buffer:GetInt())
    end
    self.playerName = buffer:GetString()
    self.playerLevel = buffer:GetShort()
    --- @type AvatarData
    self.avatarData = AvatarData(buffer)
end

--- @return void
--- @param moneyType MoneyType
--- @param quantity number
function EventGuildQuestDonationBoardInBound:AddDonate(moneyType, quantity)
    local total = quantity
    if self.moneyDict:IsContainKey(moneyType) then
        total = total + self.moneyDict:Get(moneyType)
    end
    self.moneyDict:Add(moneyType, total)
end