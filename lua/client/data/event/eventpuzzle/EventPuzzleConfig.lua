local SELECT_HERO_CONFIG = "select_hero_config.csv"
local PUZZLE_PIECE_CONFIG = "puzzle_piece_config.csv"
local PUZZLE_PIECE_REWARD_CONFIG = "piece_reward_rate.csv"
local PUZZLE_QUEST_CONFIG = "quest/daily_quest.csv"
local PUZZLE_SPECIAL_QUEST_CONFIG = "quest/special_quest.csv"

--- @class EventPuzzleConfig
EventPuzzleConfig = Class(EventPuzzleConfig)

function EventPuzzleConfig:Ctor(path)
	self.path = path
	--- @type Dictionary
	self.dictHeroPool = nil
	--- @type Dictionary
	self.dictHeroSelectedDefault = nil
	--- @type number
	self.resolvePrice = nil
	--- @type List
	self.listPuzzlePiecesReward = nil
end

--- @return void
function EventPuzzleConfig:InitHeroResource()
	self.dictHeroPool = Dictionary()
	self.dictHeroSelectedDefault = Dictionary()
	local path = string.format("%s/%s", self.path, SELECT_HERO_CONFIG)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end
	local listHeroPool = List()
	for i = 1, #parsedData do
		local slotId = tonumber(parsedData[i].slot_id);
		if slotId ~= nil then
			local heroDefaultId = tonumber(parsedData[i].hero_slot_default);
			if heroDefaultId > 0 then
				self.dictHeroSelectedDefault:Add(slotId, heroDefaultId)
			end

			listHeroPool = List()
			self.dictHeroPool:Add(slotId, listHeroPool)
		end
		local heroId = tonumber(parsedData[i].hero_id);
		listHeroPool:Add(heroId)
	end
end

--- @return List<HeroResource>
--- @param slotId number
function EventPuzzleConfig:GetHeroPool()
	if self.dictHeroPool == nil then
		self:InitHeroResource()
	end
	return self.dictHeroPool;
end

--- @return List -- <HeroResource>
--- @param slotId number
function EventPuzzleConfig:GetHeroPoolBySlotId(slotId)
	if self.dictHeroPool == nil then
		self:InitHeroResource()
	end
	return self.dictHeroPool:Get(slotId);
end


function EventPuzzleConfig:GetResolvePuzzlePrice()
	if self.resolvePrice == nil then
		local path = string.format("%s/%s", self.path, PUZZLE_PIECE_CONFIG)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		local listHeroPool = List()
		for i = 1, #parsedData do
			self.resolvePrice = tonumber(parsedData[i].coin_value)
		end
	end
	return self.resolvePrice
end

function EventPuzzleConfig:GetNumberOfPuzzlePiece()
	if self.numberOfPuzzlePieces == nil then
		local path = string.format("%s/%s", self.path, PUZZLE_PIECE_CONFIG)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		local listHeroPool = List()
		for i = 1, #parsedData do
			self.resolvePrice = tonumber(parsedData[i].coin_value)
			self.numberOfPuzzlePieces = tonumber(parsedData[i].number_piece)
		end
	end
	return self.numberOfPuzzlePieces
end

function EventPuzzleConfig:GetListPuzzlePieceReward()
	if self.listPuzzlePiecesReward == nil then
		self.listPuzzlePiecesReward = List()
		local path = string.format("%s/%s", self.path, PUZZLE_PIECE_REWARD_CONFIG)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end

		local totalRate = 0
		for i = 1, #parsedData do
			totalRate = totalRate + tonumber(parsedData[i].rate)
		end
		for i = 1, #parsedData do
			--- @type RewardInBound
			local rewardInBound = RewardInBound.CreateByParams(parsedData[i]):GetIconData()
			rewardInBound.rate = MathUtils.RoundDecimal(tonumber(parsedData[i].rate) / totalRate * 100,2)
			self.listPuzzlePiecesReward:Add(rewardInBound)
		end
	end
	return self.listPuzzlePiecesReward
end


--- @return Dictionary --- { slotId = HeroResource }
function EventPuzzleConfig:GetHeroSelectedDefault()
	if self.dictHeroSelectedDefault == nil then
		self:InitHeroResource()
	end
	return self.dictHeroSelectedDefault;
end


--- @return Dictionary
function EventPuzzleConfig:GetQuestConfigDict()
	if self.questConfigDict == nil then
		local path = string.format("%s/%s", self.path, PUZZLE_QUEST_CONFIG)
		self.questConfigDict = QuestElementConfig.ReadQuestConfigFromPath(path)
	end
	return self.questConfigDict
end

--- @return Dictionary
function EventPuzzleConfig:GetSpecialQuestConfigDict()
	if self.specialQuestConfigDict == nil then
		local path = string.format("%s/%s", self.path, PUZZLE_SPECIAL_QUEST_CONFIG)
		self.specialQuestConfigDict = QuestElementConfig.ReadQuestConfigFromPath(path)
	end
	return self.specialQuestConfigDict
end




