require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.resovlePuzzleLayout.PuzzlePieceOpenData"
--- @class EventPuzzleModel : EventPopupModel
EventPuzzleModel = Class(EventPuzzleModel, EventPopupModel)

function EventPuzzleModel:Ctor()
	EventPopupModel.Ctor(self)

	--- @type Dictionary
	self.dictHeroSelected = Dictionary()

	--- @type Dictionary
	self.dictHeroItemSelected = Dictionary()

	--- @type Dictionary
	self.dictUnlockState = Dictionary()

	--- @type boolean
	self.isConfirmed = nil

	--- @type Dictionary
	self.puzzleDataDict = Dictionary()

	--- @type number
	self.completedSlot = 0

	--- @type PuzzlePieceOpenData
	self.currentData = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventPuzzleModel:ReadInnerData(buffer)
	local size = buffer:GetByte()
	for i = 1, size do
		self.puzzleDataDict:Add(buffer:GetInt(), PuzzlePieceOpenData.CreateByBuffer(buffer))
	end
	self.isConfirmed = size > 0

	self.completedSlot = buffer:GetInt()
	self.currentData = self.puzzleDataDict:Get(self.completedSlot + 1)

	local size = buffer:GetShort()
	---@type List
	self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfigDict(), size)
	local size = buffer:GetShort()
	---@type List
	self.listQuestData:AddAll(QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetSpecialQuestConfigDict(), size))
	self:InitListHeroSelectedData()
	self:_FilterDailyQuest()
	self:SortQuestByData()
	self:CheckResourceOnSeason()
end

function EventPuzzleModel:_FilterDailyQuest()
	local totalHidden = 0
	--- @type QuestUnitInBound
	local questData
	local questCount = self.listQuestData:Count()
	for i = questCount, 1, -1 do
		--- @type QuestUnitInBound
		local questUnitData = self.listQuestData:Get(i)
		if questUnitData.questState == QuestState.HIDDEN or questUnitData.questState == QuestState.LOCKED then
			self.listQuestData:RemoveByIndex(i)
			totalHidden = totalHidden + 1
		end
	end
	if questData ~= nil then
		questData.number = questData.number - totalHidden
	end
end

--- @return  PuzzlePieceOpenData
function EventPuzzleModel:GetCurrentPuzzleData()
	return self.currentData
end

--- @return  PuzzlePieceOpenData
function EventPuzzleModel:UpdateCurrentPuzzleData()
	if self.currentData ~= nil then
		self.currentData.isClaimed = true
	end
	self.currentData = self.puzzleDataDict:Get(self.completedSlot + 1)
end

--- @return  PuzzlePieceOpenData
function EventPuzzleModel:UnlockPuzzleState(id)
	self.currentData.heroPieceHistories:Add(id, true)
end

--- @return  PuzzlePieceOpenData
function EventPuzzleModel:GetPuzzleData(id)
	return self.puzzleDataDict:Get(id)
end

function EventPuzzleModel:HasNotification()
	for i = 1, 3 do
		if self:IsTabNotified(i) then
			return true
		end
	end
	return false
end

function EventPuzzleModel:IsTabNotified(tab)
	if tab == EventPuzzleTab.SELECT_HERO then
		return self.dictHeroSelected:Count() < 3 or not self.isConfirmed
	elseif tab == EventPuzzleTab.PUZZLE then
		return InventoryUtils.GetMoney(MoneyType.EVENT_PUZZLE_PIECE) > 0 and self.completedSlot < 4
	elseif tab == EventPuzzleTab.QUEST then
		return self:HasQuestDoneNotClaimed()
	else
	end
	return false
end

function EventPuzzleModel:OnClaimQuestSuccess(questId)
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

function EventPuzzleModel:SortQuestByData()
	self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

--- @return boolean
function EventPuzzleModel:IsCompletePuzzle()
	return self.completedSlot == 4
end

function EventPuzzleModel:HasSelectHeroForPuzzle()

end

--- @return EventPuzzleConfig
function EventPuzzleModel:GetConfig()
	return EventPopupModel.GetConfig(self)
end

function EventPuzzleModel:HasQuestDoneNotClaimed()
	--- @param v QuestUnitInBound
	for _, v in pairs(self.listQuestData:GetItems()) do
		if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
			return true
		end
	end
	return false
end

--- @return boolean
function EventPuzzleModel:CheckUnlockSlot(slot)
	--- @type PuzzlePieceOpenData
	local puzzleData = self:GetCurrentPuzzleData()

	return puzzleData.heroPieceHistories:Get(slot)
end

function EventPuzzleModel:InitListHeroSelectedData()
	if self:IsCompletePuzzle() or self.isConfirmed then
		self.dictHeroSelected:Clear()
		if self.puzzleDataDict:Count() > 0 then
			for k, v in pairs(self.puzzleDataDict:GetItems()) do
				self.dictHeroSelected:Add(k, v.heroId)
			end
		end
	end
end

---@return List --QuestDataInBound
---@param tabId number
function EventPuzzleModel:GetListQuestData()
	local lstResult = self:GetConfig():GetQuestConfigDict()
	return QuestDataInBound.SortQuestByData(QuestDataInBound.SortQuestByQuestId(lstResult))
end

function EventPuzzleModel:CheckResourceOnSeason()
	local endTime = self.timeData.endTime
	local savedEndSeason = zg.playerData.remoteConfig.eventPuzzleEnd or endTime
	if savedEndSeason ~= endTime then
		self:ClearMoneyType()
	end
	zg.playerData.remoteConfig.eventPuzzleEnd = endTime
	zg.playerData:SaveRemoteConfig()
end

function EventPuzzleModel:ClearMoneyType()
	local clearResource = function(moneyType)
		local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
		InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
	end
	clearResource(MoneyType.EVENT_PUZZLE_PIECE)
end

--- @class EventPuzzleTab
EventPuzzleTab = {
	SELECT_HERO = 1,
	PUZZLE = 2,
	QUEST = 3
}