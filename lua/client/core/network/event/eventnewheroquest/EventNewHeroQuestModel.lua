--- @class EventNewHeroQuestModel : EventPopupModel
EventNewHeroQuestModel = Class(EventNewHeroQuestModel, EventPopupModel)

function EventNewHeroQuestModel:Ctor()
    --- @type List
    self.listQuestData = List()

    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroQuestModel:ReadInnerData(buffer)
    --- @type List
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfig())
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

--- @return EventNewHeroQuestConfig
function EventNewHeroQuestModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewHeroQuestModel:HasNotification()
    return QuestDataInBound.HasDoneNotClaimQuest(self.listQuestData)
end

--- @return QuestUnitInBound
--- @param indexOfList number
function EventNewHeroQuestModel:GetDataByIndexOfList(indexOfList)
    return self.listQuestData:Get(indexOfList)
end

function EventNewHeroQuestModel:RequestClaimQuest(questId, callback)
    local onSuccess = function(rewardList)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self:OnClaimQuestSuccess(questId)
        if callback then
            callback()
        end
    end
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_NEW_HERO_QUEST_CLAIM, questId, onSuccess)
end

function EventNewHeroQuestModel:OnClaimQuestSuccess(questId)
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(i)
        if questUnitInBound.questId == questId then
            questUnitInBound.questState = QuestState.COMPLETED
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end
