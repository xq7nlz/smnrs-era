--- @class AchievementQuestInBound
AchievementQuestInBound = Class(AchievementQuestInBound)

function AchievementQuestInBound:Ctor()
    --- @type boolean
    self.hasNotification = nil
    --- @type boolean
    self.needRequest = nil
    ----- @type List
    self.listAchievement = nil
    --- @type Dictionary
    self.archivedQuestGroupDict = nil
    --- @type Dictionary<number, QuestElementConfig>
    self.config = ResourceMgr.GetQuestConfig():GetAchievement()
end

--- @param buffer UnifiedNetwork_ByteBuf
function AchievementQuestInBound:ReadBuffer(buffer)
    self.listAchievement = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config)
    self:_AdjustAchievementInput()
end

function AchievementQuestInBound:_AdjustAchievementInput()
    for i = 1, self.listAchievement:Count() do
        --- @type QuestUnitInBound
        local data = self.listAchievement:Get(i)
        --- @type QuestElementConfig
        local questElementConfig = self.config:Get(data.questId)
        data.groupId = questElementConfig.groupId
        data.orderInGroup = questElementConfig.orderInGroup
    end
end

--- @return List|QuestUnitInBound
function AchievementQuestInBound:GetListAchievementData()
    return self.listAchievement
end

function AchievementQuestInBound:CheckNotification()
    self.hasNotification = QuestDataInBound.HasDoneNotClaimQuest(self.listAchievement)
end