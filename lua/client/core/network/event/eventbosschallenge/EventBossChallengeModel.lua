require "lua.client.core.network.event.eventBossChallenge.BossChallengeDefenderTeamInBound"
--- @class EventBossChallengeModel : EventPopupModel
EventBossChallengeModel = Class(EventBossChallengeModel, EventPopupModel)

function EventBossChallengeModel:Ctor()
    ---@type EventLoginData
    self.loginData = nil
    ---@type List
    self.listOfLimitedPackStatistics = List()
    ---@type List
    self.listDailyQuest = List()
    ---@type number
    self.currentStage = nil
    --- @type List
    self.heroRandomPoolList = List()
    --- @type List
    self.heroSelectedList = List()
    --- @type List
    self.selectedHeroWithStateList = List()
    --- @type List
    self.listDefenderTeam = List()
    --- @type Dictionary
    self.bossChallengeDetailDict = Dictionary()
    ---@type number
    self.currentFinalStageTeamId = nil
    --- @type BossChallengeTowerBattleResultInBound
    self.bossChallengeResultInBound = nil
    --- @type List
    self.defenderHeroState = nil
    --- @type BossChallengeRankingInBound
    self.BossChallengeRankingInBound = nil
    --- @type boolean
    self.isBoughtPremiumPass = nil
    --- @type List
    self.premiumPassClaimedStageList = List()
    EventPopupModel.Ctor(self)
end

--- @return EventBossChallengeConfig
function EventBossChallengeModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventBossChallengeModel:ReadInnerData(buffer)
    ---@type EventBossChallengeConfig
    self.config = self:GetConfig()
    self.loginData = EventLoginData(buffer)
    self:ClearOldData()
    for _ = 1, buffer:GetByte() do
        self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    end

    self.currentStage = buffer:GetShort()
    self.currentStage = self.currentStage + 1
    self.highestStageTime = buffer:GetLong()
    self.lastTimeRollFree = buffer:GetLong()
    local size = buffer:GetByte()
    for i = 1, size do
        local heroIndex = buffer:GetInt()
        self.heroRandomPoolList:Add(heroIndex)
    end

    size = buffer:GetByte()
    for i = 1, size do
        local heroIndex = buffer:GetInt()
        self.heroSelectedList:Add(heroIndex)
    end

    size = buffer:GetByte()
    for i = 1, size do
        local selectedHeroStage = {}
        selectedHeroStage.selectHeroId = buffer:GetInt()
        selectedHeroStage.hpPercent =  buffer:GetLong()/1000000000
        selectedHeroStage.power = buffer:GetByte()
        self.selectedHeroWithStateList:Add(selectedHeroStage)
    end

    self.battleTeamInfomation = TeamFormationInBound.CreateByBufferWithHeroResourceList(buffer,
            self:GetConfig():GetHeroResource())

    self.usedReviveTime = buffer:GetInt()

    size = buffer:GetByte()
    for i = 1, size do
        self.listDefenderTeam:Add(BossChallengeDefenderTeamInBound(buffer))
    end

    for i = 1, self.listDefenderTeam:Count() do
        local item = self.listDefenderTeam:Get(i)
        local listHeroState = item.listHeroState
        self.bossChallengeDetailDict:Add(item.stageId, listHeroState)
    end

    self.currentFinalStageTeamId = buffer:GetInt()
    self.isBoughtPremiumPass = buffer:GetBool()
    size = buffer:GetByte()
    for i = 1, size do
        self.premiumPassClaimedStageList:Add(buffer:GetInt())
    end

    local sizeQuest = buffer:GetByte()
    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetDailyQuestConfig(), sizeQuest)
end

function EventBossChallengeModel:ClearOldData()
    self.heroRandomPoolList:Clear()
    self.heroSelectedList:Clear()
    self.selectedHeroWithStateList:Clear()
    self.listDefenderTeam:Clear()
    self.bossChallengeDetailDict:Clear()
end

--- @return Dictionary
function EventBossChallengeModel:AddPremiumPassClaimedStageList(stage)
    if self.premiumPassClaimedStageList:IsContainValue(stage) == false then
        self.premiumPassClaimedStageList:Add(stage)
    end
end

--- @return Dictionary
function EventBossChallengeModel:ConvertHeroWithStateToDict()
    --- @type Dictionary
    local HeroWithStateDict = Dictionary()
    for i = 1, self.selectedHeroWithStateList:Count() do
        local item = self.selectedHeroWithStateList:Get(i)
        local heroState = {}
        heroState.hpPercent = item.hpPercent
        heroState.power = item.power
        HeroWithStateDict:Add(item.selectHeroId, heroState)
    end
    return HeroWithStateDict
end

function EventBossChallengeModel:AddNumberOfBoughtLimitedPack(id)
    ---@type LimitedPackStatisticsInBound
    local pack = self:GetPackData(id)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", id))
    end
end

function EventBossChallengeModel:GetPackData(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = id
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

function EventBossChallengeModel:GetNumberOfBoughtLimitedPack(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v:GetNumberOfBought()
        end
    end
    return 0
end

function EventBossChallengeModel:IsClaim()
    if self.loginData.lastClaimLoginTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.loginData.lastClaimLoginTime
                or self.loginData.lastClaimDay >= 7
    end
    return nil
end

function EventBossChallengeModel:HasDailyDoneNotClaimed()
    return not self.loginData:IsFreeClaim()
end

-----------------------------------------Quest-----------------------------------------

--- @return List
function EventBossChallengeModel:GetListDailyQuestData()
    return self.listDailyQuest
end

--- @return List
function EventBossChallengeModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

function EventBossChallengeModel:OnClaimQuestDailySuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in ipairs(self.listDailyQuest:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @param listQuestData List|QuestUnitInBound
function EventBossChallengeModel:SortQuestByListQuestData(listQuestData)
    local count = listQuestData:Count()
    local index = 1
    local firstIndex = 1
    for _ = 1, count do
        --- @type QuestUnitInBound
        local questData = listQuestData:Get(index)
        if questData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, firstIndex)
            firstIndex = firstIndex + 1
        elseif questData.questState == QuestState.COMPLETED then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, count)
            index = index - 1
        end
        index = index + 1
    end
    return listQuestData
end
-----------------------------------------Notification-----------------------------------------

function EventBossChallengeModel:HasNotification()
    return self:IsTabNotified(EventBossChallengeTab.CHALLENGE_TOWER)
            or self:IsTabNotified(EventBossChallengeTab.BOSS_QUEST)
            or self:IsTabNotified(EventBossChallengeTab.BOSS_PACK)
end

function EventBossChallengeModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventBossChallengeModel:HasFreeOrAdsBundleLeft()
    ---@type BossChallengeGroupPackOfProducts
    local packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventBossChallengeBundleStore():GetCurrentPack()
    --- @param v BossChallengeGroupProductConfig
    for _,v in pairs(packOfProducts.groupPackDict:GetItems()) do
        --- @param k ProductConfig
        for _,k in ipairs(v.listProductConfig:GetItems()) do
            if k.priceType == IapPackPriceType.FREE or k.priceType == IapPackPriceType.WATCH_ADS then
                if self:GetNumberOfBoughtLimitedPack(k.id) < k.stock then
                    return true
                end
            end
        end
    end
    return false
end

function EventBossChallengeModel:HasTicket()
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_BOSS_CHALLENGE_TICKET)
    return currentValue > 0
end

function EventBossChallengeModel:IsTabNotified(eventBossChallengeTab)
    if eventBossChallengeTab == EventBossChallengeTab.CHALLENGE_TOWER then
        return self:HasTicket()
    elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_PACK then
        return self:HasFreeOrAdsBundleLeft()
    elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_QUEST then
        return self:HasClaimableDailyQuest()
    end
    return false
end

-----------------------------------------Boss-----------------------------------------


--- @class EventBossChallengeTab
EventBossChallengeTab = {
    PREMIUM_PASS = 1,
    CHALLENGE_TOWER = 2,
    BOSS_QUEST = 3,
    BOSS_PACK = 4,
    BOSS_LEADER_BOARD = 5
}