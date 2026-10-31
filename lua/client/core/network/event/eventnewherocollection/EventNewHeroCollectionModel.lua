--- @class EventNewHeroCollectionModel : EventPopupModel
EventNewHeroCollectionModel = Class(EventNewHeroCollectionModel, EventPopupModel)

function EventNewHeroCollectionModel:Ctor()
    --- @type List
    self.listQuestData = List()

    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroCollectionModel:ReadInnerData(buffer)
    local size = buffer:GetByte()
    --- @type List
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfig(), size)
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

--- @return EventNewHeroCollectionConfig
function EventNewHeroCollectionModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewHeroCollectionModel:HasNotification()
    return QuestDataInBound.HasDoneNotClaimQuest(self.listQuestData)
end

--- @return QuestUnitInBound
--- @param indexOfList number
function EventNewHeroCollectionModel:GetDataByIndexOfList(indexOfList)
    return self.listQuestData:Get(indexOfList)
end

function EventNewHeroCollectionModel:RequestClaimQuest(questId, callback)
    local onSuccess = function(rewardList)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self:OnClaimQuestSuccess(questId)
        if callback then
            callback()
        end
    end
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_NEW_HERO_COLLECTION_QUEST_CLAIM, questId, onSuccess)
end

function EventNewHeroCollectionModel:OnClaimQuestSuccess(questId)
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(i)
        if questUnitInBound.questId == questId then
            questUnitInBound.questState = QuestState.COMPLETED
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end
