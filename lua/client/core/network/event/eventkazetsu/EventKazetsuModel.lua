--- @class EventKazetsuModel : EventPopupModel
EventKazetsuModel = Class(EventKazetsuModel, EventPopupModel)

function EventKazetsuModel:Ctor()
	--- @type Dictionary
	self.numberBuyDataDict = Dictionary()
	--- @type EventLoginData
	self.eventLoginData = nil
	--- @type List
	self.listOfLimitedPackStatistics = List()
	--- @type Dictionary
	self.roundRewards = nil
	self.numberBuyBossTurn = 0

	self.numberSummon = 0
	self.lastFreeSummon = 0
	--- @type List
	self.listQuestData = List()
	--- @type List
	self.summonQuestMap = List()
	--- @type List
	self.dailyQuestMap = List()
	--- @type List
	self.heroRandomPoolList = List()
	--- @type List
	self.heroSelectedList = List()
	--- @type List<HeroResource>
	self.listHeroResourceRoll = List()
	--- @type List<HeroResource>
	self.listHeroResourceSelected = List()
	--- @type number
	self.lastTimeRollFree = 0
	--- @type List
	self.selectedHeroWithStateList = List()

	---@type number
	self.dailyNumberBuyStamina = 0
	---@type number
	self.highestDamage = 0
	--- @type number
	self.usedReviveTime = 0
	EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventKazetsuModel:ReadInnerData(buffer)
	--- @type EventLoginData
	self.eventLoginData = EventLoginData(buffer)

	self:ClearOldData()

	local size = buffer:GetByte()
	for i = 1, size do
		local packId = buffer:GetShort()
		local numberOfBought = buffer:GetShort()
		self.numberBuyDataDict:Add(packId, numberOfBought)
	end

	--- fake boss
	self.numberBuyBossTurn = buffer:GetByte()
	self.numberSummon = buffer:GetInt()
	self.lastFreeSummon = buffer:GetLong()
	self.currentStage = buffer:GetShort()
	self.currentStage = self.currentStage + 1
	self.highestStageTime = buffer:GetLong()
	self.lastTimeRollFree = buffer:GetLong()
	size = buffer:GetByte()
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
	self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer,
			self:GetConfig():GetListKazetsuGiftQuestConfig(), size)
	size = buffer:GetByte()
	self.summonQuestMap = QuestDataInBound.ReadListQuestFromBuffer(buffer,
			self:GetConfig():GetListKazetsuSummonQuestConfig(), size)
	size = buffer:GetByte()
	self.dailyQuestMap = QuestDataInBound.ReadListQuestFromBuffer(buffer,
			self:GetConfig():GetListKazetsuDailyQuestConfig(), size)

end
--- @return Dictionary
function EventKazetsuModel:ConvertHeroWithStateToDict()
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


function EventKazetsuModel:ReviveHero(inventoryId)
	self.usedReviveTime = self.usedReviveTime + 1
	for i = 1, self.selectedHeroWithStateList:Count() do
		local heroInfo = self.selectedHeroWithStateList:Get(i)
		if inventoryId == heroInfo.selectHeroId then
			heroInfo.hpPercent = 1
		end
	end
end


function EventKazetsuModel:ClearOldData()
	self.listOfLimitedPackStatistics:Clear()
	self.heroRandomPoolList:Clear()
	self.listQuestData:Clear()
	self.summonQuestMap:Clear()
	self.dailyQuestMap:Clear()
	self.numberBuyDataDict:Clear()
	self.heroSelectedList:Clear()
	self.selectedHeroWithStateList:Clear()
end

function EventKazetsuModel:AddNumberBuy(packId, count)
	---@type NumberBuyData
	local numberBuyData = self:GetNumberBuy(packId)
	self.numberBuyDataDict:Add(packId, numberBuyData + count)
end

---@return number
function EventKazetsuModel:GetNumberBuy(packId)
	if (self.numberBuyDataDict:IsContainKey(packId)) then
		return tonumber(self.numberBuyDataDict:Get(packId))
	else
		return 0
	end
end
--- @return EventKazetsuConfig
function EventKazetsuModel:GetConfig()
	return EventPopupModel.GetConfig(self)
end

function EventKazetsuModel:IsClaim()
	if self.eventLoginData.lastClaimLoginTime ~= nil then
		return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.eventLoginData.lastClaimLoginTime
				or self.eventLoginData.lastClaimDay >= 7
	end
	return nil
end

function EventKazetsuModel:HasDailyDoneNotClaimed()
	return not self.eventLoginData:IsFreeClaim()
end

function EventKazetsuModel:HasNotification()
	--- thêm điều kiện nếu cần
	local hasDailyNoti = self:HasDailyDoneNotClaimed()
	local hasColectionNoti = self:QuestHasNotClaimed()
	return hasDailyNoti or hasColectionNoti
end

function EventKazetsuModel:BuyBossTurnSuccess(boughtTurn)
	self.numberBuyBossTurn = self.numberBuyBossTurn + boughtTurn
end

function EventKazetsuModel:IsTabNotified(newServerWeek)
	if newServerWeek == EventKazetsuTab.CHECK_IN then
		return self:HasDailyDoneNotClaimed()
	elseif newServerWeek == EventKazetsuTab.GIFT then
		return self:QuestHasNotClaimed()
	else
		--- do some thing if it's arena
	end
	return false
end

--- @return List
function EventKazetsuModel:GetListQuestData()
	return self.listQuestData
end

function EventKazetsuModel:QuestHasNotClaimed()
	--- @param v QuestUnitInBound
	for _, v in pairs(self.listQuestData:GetItems()) do
		if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
			return true
		end
	end
	return false
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventKazetsuModel:GetLimitedPackStatisticsInBound(packId)
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

--- @param packId number
function EventKazetsuModel:IncreaseNumberOfBoughtLimitedPack(packId)
	local pack = self:GetLimitedPackStatisticsInBound(packId)
	if pack ~= nil then
		pack:IncreaseNumberOfBought()
	else
		XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
	end
end

--- @return number
--- @param summonType SummonType
function EventKazetsuModel:GetTimeFreeSummon()
	local serverTime = TimeUtils.GetTimeEndDayFromSec(zg.timeMgr:GetServerTime())
	return serverTime - zg.timeMgr:GetServerTime() + 1
end

--- @return number
--- @param summonType SummonType
function EventKazetsuModel:IsAvailableFreeSummon()
	local serverTime = zg.timeMgr:GetServerTime()
	return self.lastFreeSummon - TimeUtils.GetTimeStartDayFromSec(serverTime) < 0
end

--- @return number
function EventKazetsuModel:HasFreeSummon()
	return self:IsAvailableFreeSummon()
end


function EventKazetsuModel:OnClaimQuestSuccess(questId)
	for i = 1, self.listQuestData:Count() do
		--- @type QuestUnitInBound
		local questData = self.listQuestData:Get(i)
		if questData.questId == questId then
			questData.questState = QuestState.COMPLETED
			break
		end
	end
	self:SortQuestByData()
end

function EventKazetsuModel:SortQuestByData()
	self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

--- @class EventKazetsuTab
EventKazetsuTab = {
	CHECK_IN = 1,
	BUNDLE = 2,
	GIFT = 3,
	BOSS = 4,
	TRIAL = 5
}