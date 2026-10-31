--- @class QuestElementConfig
QuestElementConfig = Class(QuestElementConfig)

function QuestElementConfig:Ctor()
    --- @type QuestType
    self._questType = nil
    --- @type Dictionary -- <reqId, reqNum>
    self._listRequirements = Dictionary()
    --- @type List
    self._listUnlockRequirements = List()
    --- @type number
    self.groupId = nil
    --- @type number
    self.orderInGroup = nil
    --- @type List {RewardInBound}
    self._listReward = nil
    --- @type string
    self._keyRecordProgress = nil
    --- @type boolean
    self.isSpecial =nil
    --- @type number
    self._featureMapping = nil
    --- @type {}
    self._featureMappingData = nil

    self.isSelectionReward = false
    ---@type List
    self.rewardSelectionList = nil
    ---@type Dictionary
    self.rewardSelectionItemDict = nil

end

--- @param questType number
function QuestElementConfig:SetQuestType(questType)
    self._questType = questType
    if questType == QuestType.GUILD_MARKET_BUY then
        self._featureMapping = FeatureType.BLACK_MARKET
        self._featureMappingData = MarketType.GUILD_MARKET
    elseif questType == QuestType.ARENA_WIN then
        self._featureMapping = FeatureType.ARENA
    elseif questType == QuestType.SUMMON_HERO_BY_PREMIUM_SCROLL then
        self._featureMapping = FeatureType.SUMMON
        self._featureMappingData = { ['summonType'] = SummonType.Heroic }
    end
end

--- @return string
function QuestElementConfig:GetKeyRecordProgress()
    if QuestDataInBound.IsConsecutiveQuest(self._questType) then
        return self._keyRecordProgress
    end
    return nil
end

--- @param parsedData table
function QuestElementConfig:SetRequirements(parsedData)
    self:AddRequirement(1, tonumber(parsedData.requirement_1))
    self:AddRequirement(2, tonumber(parsedData.requirement_2))
    self:AddRequirement(3, tonumber(parsedData.requirement_3))
    self:AddRequirement(4, tonumber(parsedData.requirement_4))
    self:AddRequirement(5, tonumber(parsedData.requirement_5))
    self:AddRequirement(6, tonumber(parsedData.requirement_6))

    self:_InitKeyRecordProgress()
end

function QuestElementConfig:SetUnlockRequirements(parsedData)
    for i = 1, 4 do
        local unlockReq = tonumber(parsedData["unlock_requirement_" .. i])
        if MathUtils.IsNumber(unlockReq) == true then
            self._listUnlockRequirements:Add(unlockReq)
        end
    end
end
function QuestElementConfig:SetIsSpecial(parsedData)
    self.isSpecial = false
    local isSpecialData = tostring(parsedData["is_special_quest"])
    if isSpecialData == "TRUE" then
            self.isSpecial = true
    end
end
--- @param reqId number
--- @param reqNum number
function QuestElementConfig:AddRequirement(reqId, reqNum)
    if self._questType == QuestType.DAILY_QUEST_COMPLETE then
        return
    end
    if MathUtils.IsNumber(reqNum) == false then
        return
    end
    self._listRequirements:Add(reqId, reqNum)
end

--- @param selectReward SelectReward
function QuestElementConfig:AddSelectionResData(selectionID,selectReward)
    if self.rewardSelectionList == nil then
        self.rewardSelectionList = List()
    end
    if (self.rewardSelectionItemDict == nil) then
        self.rewardSelectionItemDict = Dictionary()
    end
    self.rewardSelectionList:Add(selectReward)
    self.rewardSelectionItemDict:Add(selectionID,selectReward)
end

--- @param reward RewardInBound
function QuestElementConfig:AddResData(reward)
    if self._listReward == nil then
        self._listReward = List()
    end
    if reward ~= nil then
        self._listReward:Add(reward)
    end
end

--- @param rewards List
function QuestElementConfig:AddListResData(rewards)
    if self._listReward == nil then
        self._listReward = List()
    end
    if rewards ~= nil then
        self._listReward:AddAll(rewards)
    end
end

--- @param featureMapping number
function QuestElementConfig:SetFeatureMappingData(featureMapping)
    if MathUtils.IsNumber(featureMapping) == true and self._featureMapping == nil then
        self._featureMapping = featureMapping
    end
end

--- @return QuestType
function QuestElementConfig:GetQuestType()
    return self._questType
end
--- @return boolean
function QuestElementConfig:GetIsSpecial()
    return self.isSpecial
end
--- @return Dictionary -- <reqId, reqNum>
function QuestElementConfig:GetRequirements()
    return self._listRequirements
end

--- @return List -- <reqId>
function QuestElementConfig:GetUnlockRequirements()
    return self._listUnlockRequirements
end

--- @return number
function QuestElementConfig:GetMainRequirementTarget()
    return self._listRequirements:Get(1)
end

--- @return number
--- @param reqIndex number
function QuestElementConfig:GetRequirementsByIndex(reqIndex)
    if self._listRequirements:IsContainKey(reqIndex) == true then
        return self._listRequirements:Get(reqIndex)
    end
    return nil
end

--- @return number
function QuestElementConfig:GetRequirementsToLocalize()
    for i = 6, 1, -1 do
        if self._listRequirements:IsContainKey(i) == true then
            return self._listRequirements:Get(i)
        end
    end
    return nil
end

--- @return RewardInBound
function QuestElementConfig:GetMainRewardData()
    return self._listReward:Get(1)
end

--- @return List
function QuestElementConfig:GetListReward()
    return self._listReward
end

--- @param fixedTarget number
function QuestElementConfig:SetMainRequirementTarget(fixedTarget)
    self._listRequirements:Add(1, fixedTarget)
end

--- @return number
function QuestElementConfig:GetFeatureMappingData()
    return self._featureMapping, self._featureMappingData
end

function QuestElementConfig:IsFeatureMappingAvailable()
    return self._featureMapping > 0
end

--- @param mainReq number
function QuestElementConfig:OverrideMainReq(mainReq)
    self._listRequirements:Add(1, mainReq)
end

--- @return QuestElementConfig
--- @param parsedData {quest_type, feature_mapping}
function QuestElementConfig.GetInstanceFromCsv(parsedData)
    local quest = QuestElementConfig()
    quest:SetFeatureMappingData(tonumber(parsedData.feature_mapping or -1))
    quest:SetQuestType(tonumber(parsedData.quest_type))
    quest:SetRequirements(parsedData)
    quest:SetUnlockRequirements(parsedData)
    quest:SetIsSpecial(parsedData)
    local sortId = tonumber(parsedData.sort_id)
    if MathUtils.IsNumber(sortId) then
        quest.groupId = math.floor(sortId / 1000)
        quest.orderInGroup = sortId % 1000
    end
    local rewardInBound = RewardInBound.CreateByParams(parsedData)
    quest:AddResData(rewardInBound)
    return quest
end

function QuestElementConfig:_InitKeyRecordProgress()
    local questType = self:GetQuestType()
    if QuestDataInBound.IsConsecutiveQuest(questType) == false then
        return
    end
    self._keyRecordProgress = tostring(questType)
    for i = 2, 5 do
        local val = -1
        if self._listRequirements:IsContainKey(i) == true then
            val = self._listRequirements:Get(i)
        end
        self._keyRecordProgress = self._keyRecordProgress .. "_" .. tostring(val)
    end
end

--- @return Dictionary
function QuestElementConfig.ReadQuestConfigFromPath(path)
    local questDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local dailyQuestId
    --- @type QuestElementConfig
    local questElementConfig
    for i = 1, #parsedData do
        local questId = tonumber(parsedData[i].quest_id)
        if questId ~= nil then
            questElementConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
            --- @type QuestType
            local questType = tonumber(parsedData[i].quest_type)
            if questType == QuestType.EVENT_COMPLETED_COLLECTION_QUEST then
                dailyQuestId = questId
            end
            questDict:Add(questId, questElementConfig)
        else
            questElementConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
        end
    end
    if dailyQuestId ~= nil then
        questElementConfig = questDict:Get(dailyQuestId)
        questElementConfig:SetMainRequirementTarget(questDict:Count() - 1)
    end
    return questDict
end