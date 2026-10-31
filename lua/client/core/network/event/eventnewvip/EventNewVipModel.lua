require "lua.client.core.network.event.EventPopupModel"
--- @class EventNewVipModel : EventPopupModel
EventNewVipModel = Class(EventNewVipModel, EventPopupModel)

function EventNewVipModel:Ctor()
	--- @type List
	self.listQuestData = List()

	EventPopupModel.Ctor(self)
end

--- @return EventNewVipConfig
function EventNewVipModel:GetConfig()
	return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewVipModel:ReadInnerData(buffer)
	local size = buffer:GetByte()
	self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer,
			self:GetConfig():GetCollectionQuestConfig(), size)
	self.config = self:GetConfig()
end

function EventNewVipModel:HasNotification()
	return self:HasQuestDoneButNotClaim()
end

function EventNewVipModel:IsTabNotified(eventTab)
	return false
end

function EventNewVipModel:OnClaimQuestSuccess(questId)
	for i = 1, self:GetListQuestData():Count() do
		--- @type QuestUnitInBound
		local questData = self.listQuestData:Get(i)
		if questData.questId == questId then
			questData.questState = QuestState.COMPLETED
			break
		end
	end
	self:SortQuestByData()
end

function EventNewVipModel:HasQuestDoneButNotClaim()
	--- @param questUnitInBound QuestUnitInBound
	for i, questUnitInBound in pairs(self:GetListQuestData():GetItems()) do
		if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
			return true
		end
	end
end

--- @return List
function EventNewVipModel:GetListQuestData()
	return self.listQuestData
end


function EventNewVipModel:SortQuestByData()
	self.listQuestData = self:SortQuestByListQuestData(self.listQuestData)
end

--- @param listQuestData List|QuestUnitInBound
function EventNewVipModel:SortQuestByListQuestData(listQuestData)
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