require "lua.client.core.network.event.EventPopupModel"
require "lua.client.core.network.event.eventZodiac.ZodiacConstellationData"
--- @class EventZodiacModel : EventPopupModel
EventZodiacModel = Class(EventZodiacModel, EventPopupModel)

function EventZodiacModel:Ctor()
	--- @type List
	self.listOfLimitedPackStatistics = List()
	--- @type Dictionary
	self.numberBuyDataDict = Dictionary()

	--- @type Dictionary
	self.exchangeStateMapServer = Dictionary()

	--- @type Dictionary
	self.exchangeStateMapClient = Dictionary()
	
	--- @type ZodiacConstellationData
	self.zodiacConstellationData = ZodiacConstellationData()

	--- @type number
	self.constellationMileStone = nil

	--- @type EventZodiacConfig
	self.config = nil

	--- @type List
	self.listQuestData = List()
	--- @type number
	self.numberRewardBonusExchange = 0

	EventPopupModel.Ctor(self)

end

--- @return EventZodiacConfig
function EventZodiacModel:GetConfig()
	return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventZodiacModel:ReadInnerData(buffer)
	self.listOfLimitedPackStatistics = List()
	local size = buffer:GetByte()
	for i = 1, size do
		self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
	end

	self.numberBuyDataDict = Dictionary()
	size = buffer:GetByte()
	for i = 1, size do
		--- @type EventActionType
		local eventActionType = buffer:GetByte()
		local numberBuyData = NumberBuyData()
		numberBuyData:ReadBuffer(buffer)
		self.numberBuyDataDict:Add(eventActionType, numberBuyData)
	end


	self.zodiacConstellationData:ReadBuffer(buffer)
	size = buffer:GetByte()
	for i = 1, size do
		self.exchangeStateMapServer:Add(buffer:GetInt(),buffer:GetBool())
	end

	self.numberRewardBonusExchange = buffer:GetInt()

	size = buffer:GetShort()
	self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer,
			self:GetConfig():GetCollectionQuestConfig(), size)
	self.config = self:GetConfig()
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventZodiacModel:GetLimitedPackStatisticsInBound(packId)
	for i = 1, self.listOfLimitedPackStatistics:Count() do
		--- @type LimitedPackStatisticsInBound
		local itemData = self.listOfLimitedPackStatistics:Get(i)
		if itemData.packId == packId then
			return itemData
		end
	end
	local default = LimitedPackStatisticsInBound()
	default.packId = packId
	self.listOfLimitedPackStatistics:Add(default)
	return default
end

function EventZodiacModel:HasFreePearlMapping()
	if self.config == nil then
		self.config = self:GetConfig()
	end
	local number = (self.config.freeOpenStarAmount - self.zodiacConstellationData.freeMapping) + InventoryUtils.GetMoney(MoneyType.SUPER_PEARL)
	return number > 0
end

--- @param packId number
function EventZodiacModel:IncreaseNumberOfBoughtLimitedPack(packId)
	local pack = self:GetLimitedPackStatisticsInBound(packId)
	if pack ~= nil then
		pack:IncreaseNumberOfBought()
	else
		XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
	end
end

function EventZodiacModel:HasNotification()
	return self:IsTabNotified(EventZodiacTab.CONSTELLATIONS) or self:IsTabNotified(EventZodiacTab.QUEST) or self:IsTabNotified(EventZodiacTab.BUNDLE)
end

function EventZodiacModel:IsTabNotified(eventZodiacTab)
	if eventZodiacTab == EventZodiacTab.CONSTELLATIONS then
		return self:HasFreePearlMapping()
	elseif eventZodiacTab == EventZodiacTab.EXCHANGE  then

	elseif eventZodiacTab == EventZodiacTab.QUEST  then
		return self:HasQuestDoneButNotClaim()
	elseif eventZodiacTab == EventZodiacTab.BUNDLE  then
		return self:HasFreeBundleLeft() or self:HasAdsBundleLeft()
	end
	return false
end

function EventZodiacModel:GetNumberExchange(id)
	if (self.numberBuyDataDict:IsContainKey(EventActionType.ZODIAC_RESOURCE_EXCHANGE)) then
		---@type NumberBuyData
		local numberBuyData =self.numberBuyDataDict:Get(EventActionType.ZODIAC_RESOURCE_EXCHANGE)
		return numberBuyData.buyStatsDict:GetOrDefault(id,0 )
	else
		return 0
	end
end

function EventZodiacModel:AddNumberExchange(id)
	if not (self.numberBuyDataDict:IsContainKey(EventActionType.ZODIAC_RESOURCE_EXCHANGE))  then
		self.numberBuyDataDict:Add(EventActionType.ZODIAC_RESOURCE_EXCHANGE,NumberBuyData())
	end
	---@type NumberBuyData
	local numberBuyData = self.numberBuyDataDict:Get(EventActionType.ZODIAC_RESOURCE_EXCHANGE)
	numberBuyData:AddNumberBoughtWithPackId(id)
	self.numberBuyDataDict:Add(EventActionType.ZODIAC_RESOURCE_EXCHANGE, numberBuyData)
end

function EventZodiacModel:OnClaimQuestSuccess(questId)
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

function EventZodiacModel:HasQuestDoneButNotClaim()
	--- @param questUnitInBound QuestUnitInBound
	for i, questUnitInBound in pairs(self:GetListQuestData():GetItems()) do
		if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
			return true
		end
	end
end

function EventZodiacModel:HasFreeBundleLeft()
	local freeBundle = self:GetLimitedPackStatisticsInBound(1)
	if freeBundle:GetNumberOfBought() < 1 then
		return true
	end
end


function EventZodiacModel:HasAdsBundleLeft()
	local adsBundle = self:GetLimitedPackStatisticsInBound(2)
	if adsBundle:GetNumberOfBought() < 3 then
		return true
	end
end

--- @return List
function EventZodiacModel:GetListQuestData()
	return self.listQuestData
end


function EventZodiacModel:SortQuestByData()
	self.listQuestData = self:SortQuestByListQuestData(self.listQuestData)
end

--- @param listQuestData List|QuestUnitInBound
function EventZodiacModel:SortQuestByListQuestData(listQuestData)
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


--- @class EventZodiacTab
EventZodiacTab = {
	CONSTELLATIONS = 1,
	EXCHANGE = 2,
	QUEST = 3,
	BUNDLE = 4
}