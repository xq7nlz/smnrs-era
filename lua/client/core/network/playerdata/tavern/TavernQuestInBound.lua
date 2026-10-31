require "lua.client.core.network.playerData.common.DynamicRewardInBound"
require "lua.client.core.network.playerData.tavern.TavernQuestParticipantInBound"

--- @class TavernQuestInBound
TavernQuestInBound = Class(TavernQuestInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TavernQuestInBound:Ctor(buffer)
    ---@type number
    self.id = buffer:GetLong()
    ---@type number
    self.star = buffer:GetByte()
    ---@type number
    self.heroNumber = buffer:GetByte()
    ---@type number
    self.heroFaction = buffer:GetByte()
    ---@type number
    self.heroClass = buffer:GetByte()
    ---@type number
    self.heroStar = buffer:GetByte()
    if self.heroStar == 255 then
        self.heroStar = -1
    end
    ---@type RewardInBound
    self.reward = RewardInBound.CreateByBuffer(buffer)
    ---@type boolean
    self.isLock = buffer:GetBool()
    ---@type TavernQuestState
    self.questState = buffer:GetByte()
    ---@type List
    self.inventoryHeroList = NetworkUtils.GetListDataInBound(buffer, TavernQuestParticipantInBound.CreateByBuffer)
    ---@type number
    self.startTime = buffer:GetLong()

    ---@type string
    self.questName = ""
    --XDebug.Log("TavernQuestInBound" .. LogUtils.ToDetail(self))
end

--- @return void
function TavernQuestInBound:ContainHeroInventoryId(heroInventoryId)
    ---@param v TavernQuestParticipantInBound
    for _, v in pairs(self.inventoryHeroList:GetItems()) do
        if v.inventoryId == heroInventoryId then
            return true
        end
    end
    return false
end

--- @return void
function TavernQuestInBound:AddHeroResource(heroResource)
    self.inventoryHeroList:Add(TavernQuestParticipantInBound.CreateByHeroResource(heroResource))
end

--- @return void
function TavernQuestInBound:RemoveHeroResource(heroResource)
    ---@param v TavernQuestParticipantInBound
    for _, v in pairs(self.inventoryHeroList:GetItems()) do
        if v.inventoryId == heroResource.inventoryId then
            self.inventoryHeroList:RemoveByReference(v)
        end
    end
end

--- @return boolean
function TavernQuestInBound:IsPassRequirementStar()
    ---@param questParticipant TavernQuestParticipantInBound
    for _, questParticipant in pairs(self.inventoryHeroList:GetItems()) do
        if self.heroStar <= 0 or questParticipant.heroStar >= self.heroStar then
            return true
        end
    end
    return false
end

--- @return boolean
function TavernQuestInBound:IsPassRequirementFaction()
    ---@param questParticipant TavernQuestParticipantInBound
    for _, questParticipant in pairs(self.inventoryHeroList:GetItems()) do
        if self.heroFaction <= 0 or ClientConfigUtils.GetFactionIdByHeroId(questParticipant.heroId) == self.heroFaction then
            return true
        end
    end
    return false
end

--- @return boolean
function TavernQuestInBound:IsPassRequirementClass()
    ---@param questParticipant TavernQuestParticipantInBound
    for _, questParticipant in pairs(self.inventoryHeroList:GetItems()) do
        if self.heroClass <= 0 or ResourceMgr.GetHeroClassConfig():GetClass(questParticipant.heroId) == self.heroClass then
            return true
        end
    end
    return false
end

--- @return void
function TavernQuestInBound:ToString()
    return LogUtils.ToDetail(self)
end