--- @class UIAchievementLayoutModel
UIAchievementLayoutModel = Class(UIAchievementLayoutModel)

--- @return void
function UIAchievementLayoutModel:Ctor()
    --- @type List
    self.filteredAchievementQuestData = nil
    --- @type Dictionary
    self.tabAchievementDict = nil
end

--- @param achievementData List
function UIAchievementLayoutModel:SetAchievementData(achievementData)
    --- @type Dictionary<questId : number, QuestElementConfig>
    local config = ResourceMgr.GetQuestConfig():GetAchievement()

    self.filteredAchievementQuestData = List()
    local filteredQuestByType = Dictionary()
    --- @param groupId number
    --- @param questUnitInBound QuestUnitInBound
    local addQuestUnitToFilter = function(groupId, questUnitInBound)
        filteredQuestByType:Add(groupId, questUnitInBound)
    end
    for i = 1, achievementData:Count() do
        --- @type QuestUnitInBound
        local unit = achievementData:Get(i)
        local orderInGroup = unit.orderInGroup
        --- @type QuestElementConfig
        local questElementConfig = config:Get(unit.questId)
        --- @type number
        local questGroupId = unit.groupId
        if filteredQuestByType:IsContainKey(questGroupId) == false then
            addQuestUnitToFilter(questGroupId, unit)
        else
            --- @type QuestUnitInBound
            local cacheQuestData = filteredQuestByType:Get(questGroupId)
            local cacheQuestState = cacheQuestData.questState
            if cacheQuestState == QuestState.COMPLETED then
                if cacheQuestData.orderInGroup < orderInGroup then
                    addQuestUnitToFilter(questGroupId, unit)
                    if unit.questState == QuestState.LOCKED or unit.questState == QuestState.LOCKED_NOT_CALCULATED then
                        if unit.number >= questElementConfig:GetMainRequirementTarget() then
                            unit.questState = QuestState.DONE_REWARD_NOT_CLAIM
                        else
                            unit.questState = QuestState.DOING
                        end
                    end
                end
            elseif cacheQuestState == QuestState.DONE_REWARD_NOT_CLAIM then
                if cacheQuestData.orderInGroup > orderInGroup and unit.questState ~= QuestState.COMPLETED then
                    addQuestUnitToFilter(questGroupId, unit)
                end
            elseif cacheQuestState == QuestState.DOING then
                if cacheQuestData.orderInGroup > orderInGroup and unit.questState ~= QuestState.COMPLETED then
                    addQuestUnitToFilter(questGroupId, unit)
                end
            end
        end
    end

    --- @param v QuestUnitInBound
    for _, v in pairs(filteredQuestByType:GetItems()) do
        self.filteredAchievementQuestData:Add(v)
    end

    self:FilterAchievementByTab()
end

function UIAchievementLayoutModel:FilterAchievementByTab()
    self.tabAchievementDict = Dictionary()
    for i = 1, self.filteredAchievementQuestData:Count() do
        --- @type QuestUnitInBound
        local questData = self.filteredAchievementQuestData:Get(i)
        local tab = math.floor(questData.groupId / 1000)
        --- @type List
        local existingList = self.tabAchievementDict:Get(tab)
        if existingList == nil then
            existingList = List()
        end
        existingList:Add(questData)
        self.tabAchievementDict:Add(tab, existingList)
    end
    for _, listQuestData in pairs(self.tabAchievementDict:GetItems()) do
        listQuestData:SortWithMethod(QuestDataInBound.SortQuestByGroupId)
    end
    for _, listQuestData in pairs(self.tabAchievementDict:GetItems()) do
        listQuestData = QuestDataInBound.SortQuestByData(listQuestData)
    end
end

--- @param groupId number
function UIAchievementLayoutModel:IsHasAchievementNotifyByTab(groupId)
    local listQuestData = self.tabAchievementDict:Get(groupId)
    return QuestDataInBound.HasDoneNotClaimQuest(listQuestData)
end
