--- @class EventBattlePassModel : EventPopupModel
EventBattlePassModel = Class(EventBattlePassModel, EventPopupModel)

function EventBattlePassModel:ReadInnerData(buffer)
    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)
    ---@type boolean
    self.isPurchasedPremium = buffer:GetBool()
    ---@type List
    self.listLevelRewardClaimed = self:GetListLevelRewardClaimed(buffer)
    ---@type List
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfigDict())
    ---@type Dictionary
    self.dicQuest = self:GetDictQuest()
    self.exp = buffer:GetLong()

    self:ReUpdateExp()

    self.lastTimeRequest = zg.timeMgr:GetServerTime()
    self:CheckResourceOnSeason()
end

function EventBattlePassModel:ReUpdateExp()
    InventoryUtils.SetBattlePassExp(self.exp)
end

function EventBattlePassModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedRemoteConfig = false
    if (zg.playerData.remoteConfig.eventBattlePassEnd == nil) then
        savedRemoteConfig = true
    end
    local savedEndSeason = zg.playerData.remoteConfig.eventBattlePassEnd or endTime
    if savedEndSeason ~= endTime or savedRemoteConfig then
        self:UpdateExp()
        zg.playerData.remoteConfig.eventBattlePassEnd = endTime
        zg.playerData.remoteConfig.firstOpen = true
        zg.playerData:SaveRemoteConfig()
    end
end
---@return boolean
function EventBattlePassModel:CheckFirstTimeOpen()
    return zg.playerData.remoteConfig.firstOpen
end

function EventBattlePassModel:SetFirstTimeOpen()
    zg.playerData.remoteConfig.firstOpen = false
    zg.playerData:SaveRemoteConfig()
end

function EventBattlePassModel:UpdateExp()
    ---@type number
    local curExp = self:GetExp()
    local maxExp = self:GetMaxExp()
    --TODO: Logic tich tru BATTLE_PASS_EXP cho mua sau
    --if (curExp >= maxExp) then
    --   XDebug.Log("SUB EXP" .. tostring(maxExp))
    --    InventoryUtils.Sub(ResourceType.Money, MoneyType.BATTLE_PASS_EXP, maxExp)
    --else
    --    InventoryUtils.Sub(ResourceType.Money, MoneyType.BATTLE_PASS_EXP, curExp)
    --end
    --TODO: Bo Logic tich tru
    InventoryUtils.Sub(ResourceType.Money, MoneyType.BATTLE_PASS_EXP, curExp)

end

function EventBattlePassModel:OnUpdatePurchasePremiumSuccess()
    self.isPurchasedPremium = true
end

function EventBattlePassModel:UpdateLevelRewardClaimed(listNewClaim)
    for _newIndex, newLevel in pairs(listNewClaim:GetItems()) do
        if (not self:RewardClaimed(newLevel)) then
            self.listLevelRewardClaimed:Add(newLevel)
        end
    end
end

-- ---@return QuestUnitInBound
---@param id number
function EventBattlePassModel:GetDictQuest()
    ---@type Dictionary
    local dicQuest = Dictionary()

    for k = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(k)
        dicQuest:Add(questUnitInBound.questId, questUnitInBound)
    end
    return dicQuest
end

function EventBattlePassModel:WeekHasQuestNotClaimed(weekid)
    local listQuestByWeek = self:GetListQuestDataByWeek(weekid)
    --- @param v QuestUnitInBound
    for _, v in pairs(listQuestByWeek:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

---@return List --QuestDataInBound
---@param weekid number
function EventBattlePassModel:GetListQuestDataByWeek(weekid)
    ---@type List
    local lstResult = List()
    ---@type Dictionary < number,QuestElementConfig>>
    local weeklyQuestRewardDict = self:GetConfig():GetDictQuestByWeek(weekid)

    for questId, questElementConfig in pairs(weeklyQuestRewardDict:GetItems()) do
        lstResult:Add(self.dicQuest:Get(tonumber(questId)))
    end
    return QuestDataInBound.SortQuestByQuestId(lstResult)
end

---@return boolean
function EventBattlePassModel:RewardClaimed(level)
    return self.listLevelRewardClaimed:IsContainValue(level)
end

---@return List
function EventBattlePassModel:GetListLevelRewardClaimed(buffer)
    ---@type number
    local sizeOfList = buffer:GetByte()
    local listLevelRewardClaimed = List()
    for _ = 1, sizeOfList do
        listLevelRewardClaimed:Add(buffer:GetInt())
    end
    return listLevelRewardClaimed
end

--- @return LevelOnEXP
function EventBattlePassModel:GetCurLevel()
    return self:GetLevelByExp(self:GetExp())
end

--- @return number
function EventBattlePassModel:GetExp()
    --local maxExp =

    return InventoryUtils.Get(ResourceType.Money, MoneyType.BATTLE_PASS_EXP)
end

--- @return LevelOnEXP
function EventBattlePassModel:GetRedundantExp()
    local curExp = self:GetExp()
    local redundantExp = tonumber(curExp - self:GetConfig():GetExpOnLevelMax())
    --XDebug.Log("redudant exp " .. tostring(self:GetConfig():GetExpOnLevelMax()))
    if (redundantExp < 0) then
        redundantExp = 0
    end
    return math.floor(redundantExp)
end

--- @return LevelOnEXP
function EventBattlePassModel:GetLevelByExp(exp)
    return self:GetConfig():GetLevelByExp(exp)
end

---@return List
function EventBattlePassModel:GetListQuest(buffer)
    ---@type number
    local sizeOfList = buffer:GetByte()
    local listQuestData = List()
    for _ = 1, sizeOfList do
        listQuestData:Add(buffer:GetInt())
    end
    return listQuestData
end

--- @return number
function EventBattlePassModel:GetTimeFreeSummon()
    local serverTime = zg.timeMgr:GetServerTime()
    return self:GetConfig():GetSummonConfig():GetFreeInterval() - (serverTime - self.lastFreeSummon) + 1
end

--- @return number
function EventBattlePassModel:GetMaxExp()
    local lstLevel = self:GetConfig():GetLevelExpRewardListConfig()
    local count = lstLevel:Count()
    ---@type LevelOnEXP
    local maxLevelOnExp = lstLevel:Get(count)
    --local maxLevel = maxLevelOnExp.level
    --local maxExp = maxLevelOnExp.exp
    --XDebug.Log("max exp " .. tostring(maxExp))
    return maxLevelOnExp.exp
end
--- @return boolean
function EventBattlePassModel:CanPurchaseLevel(curExp, curLevelIsMax)
    if (curLevelIsMax) then
        return false
    end
    local maxExp = self:GetMaxExp()
    return curExp < maxExp
end

--- @return boolean
function EventBattlePassModel:IsNotifySummon()
    return self:GetTimeFreeSummon() < 0
end

--- @return EventBattlePassConfig
function EventBattlePassModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return number
function EventBattlePassModel:GetMaxWeek()
    return self:GetConfig():GetWeeklyQuestRewardConfig():Count()
end

--- @return QuestElementConfig
function EventBattlePassModel:GetWeek(numberOfWeek)
    return self:GetConfig():GetWeeklyQuestRewardConfig():Get(numberOfWeek)
end

--- @return QuestUnitInBound
--- @param indexOfList number
function EventBattlePassModel:GetDataByIndexOfList(indexOfList)
    return self.listCollectionQuestData:Get(indexOfList)
end

--- @return boolean
function EventBattlePassModel:CanClaimAllReward()
    return self:GetListRewardCanClaim():Count() > 0
end

function EventBattlePassModel:GetListRewardExpectClaim(isPremium)
    local curExp = self:GetExp()
    local listRewardNeedClaim = List()
    local curLevel = self:GetLevelByExp(curExp).level
    local listLineReward = self:GetConfig():GetLineRewardConfig()
    ---@param lineRewardConfig LineRewardConfig
    for index, lineRewardConfig in pairs(listLineReward:GetItems()) do
        local rewardClaimed = self:RewardClaimed(lineRewardConfig.level)
        if (lineRewardConfig:CanGetReward(curLevel, isPremium)) then
            -- not rewardClaimed and
            listRewardNeedClaim:Add(lineRewardConfig)
        end
    end
    return listRewardNeedClaim
end

function EventBattlePassModel:GetNearestRewardIndexCanClaim()
    local purchasedPremium = self.isPurchasedPremium
    local curExp = self:GetExp()
    local curLevel = self:GetLevelByExp(curExp).level
    local listLineReward = self:GetConfig():GetLineRewardConfig()
    for i = listLineReward:Count(), 1, -1 do
        ---@type LineRewardConfig
        local lineRewardConfig = listLineReward:Get(i)
        local rewardClaimed = self:RewardClaimed(lineRewardConfig.level)
        if (not rewardClaimed and lineRewardConfig:CanGetReward(curLevel, purchasedPremium)) then
            return i
        end
    end
    return -1
end

---@return List --- int
function EventBattlePassModel:GetListRewardCanClaim()
    local curExp = self:GetExp()
    local listAllLevelNeedClaim = List()
    local curLevel = self:GetLevelByExp(curExp).level
    local purchasedPremium = self.isPurchasedPremium
    ---@type List
    local listLineReward = self:GetConfig():GetLineRewardConfig()
    ---@param lineRewardConfig LineRewardConfig
    for index, lineRewardConfig in pairs(listLineReward:GetItems()) do
        local rewardClaimed = self:RewardClaimed(lineRewardConfig.level)
        if (not rewardClaimed and lineRewardConfig:CanGetReward(curLevel, purchasedPremium)) then
            listAllLevelNeedClaim:Add(lineRewardConfig.level)
        end
    end
    return listAllLevelNeedClaim
end

function EventBattlePassModel:HasQuestDoneNotClaimed()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventBattlePassModel:HasNotification()
    local canClaimAllReward = self:CanClaimAllReward()
    local hasQuestNotClaimed = self:HasQuestDoneNotClaimed()
    return canClaimAllReward or hasQuestNotClaimed
end

function EventBattlePassModel:IsTabNotified(eventHeroReleaseTab)
    if eventHeroReleaseTab == EventHeroReleaseTab.DailyQuest then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listDailyQuestData)
    elseif eventHeroReleaseTab == EventHeroReleaseTab.Collection then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listCollectionQuestData)
    end
    return false
end

function EventBattlePassModel:OnClaimQuestSuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

function EventBattlePassModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventBattlePassModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventBattlePassModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param opCode OpCode
--- @param packId number
function EventBattlePassModel:AddNumberBuyOpCode(opCode, packId, number)
    if opCode == OpCode.EVENT_BATTLE_PASS_LEVEL_PURCHASE then
        self:AddNumberBuy(EventActionType.BATTLE_PASS_LEVEL_PURCHASE, packId, number)
    elseif opCode == OpCode.EVENT_BATTLE_PASS_PURCHASE then
        self:AddNumberBuy(EventActionType.BATTLE_PASS_PURCHASE, packId, number)
    end
end

--- @param opCode OpCode
--- @param packId number
function EventBattlePassModel:GetNumberBuyOpCode(opCode, packId)
    if opCode == OpCode.EVENT_BATTLE_PASS_LEVEL_PURCHASE then
        return self:GetNumberBuy(EventActionType.BATTLE_PASS_LEVEL_PURCHASE, packId)
    elseif opCode == OpCode.EVENT_BATTLE_PASS_PURCHASE then
        return self:GetNumberBuy(EventActionType.BATTLE_PASS_PURCHASE, packId)
    end
    return 0
end

--- @return boolean
function EventBattlePassModel:IsPurchaseAllLevelByGem()
    local config = self:GetConfig():GetExchangeExpConfig()
    local numberBuy = self:GetNumberBuy(EventActionType.BATTLE_PASS_EXCHANGE_EXP, config.id)
    return numberBuy >= config.limit
end