
--- @class TavernQuestParticipantInBound
TavernQuestParticipantInBound = Class(TavernQuestParticipantInBound)

--- @return void
function TavernQuestParticipantInBound:Ctor()
    ---@type number
    self.inventoryId = nil
    ---@type number
    self.heroId = nil
    ---@type number
    self.heroStar = nil
    ---@type number
    self.heroLevel = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TavernQuestParticipantInBound.CreateByBuffer(buffer)
    local data = TavernQuestParticipantInBound()
    data.inventoryId = buffer:GetLong()
    data.heroId = buffer:GetInt()
    data.heroStar = buffer:GetByte()
    data.heroLevel = buffer:GetShort()
    return data
end

--- @return void
--- @param heroResource HeroResource
function TavernQuestParticipantInBound.CreateByHeroResource(heroResource)
    local data = TavernQuestParticipantInBound()
    data.inventoryId = heroResource.inventoryId
    data.heroId = heroResource.heroId
    data.heroStar = heroResource.heroStar
    data.heroLevel = heroResource.heroLevel
    return data
end