require "lua.client.data.Event.EventZodiac.ZodiacExchangeItemData"

local COLLECTION_QUEST_PATH = "collection_quest.csv"
local EXCHANGE_PATH = "exchange/exchange_reward.csv"
local BONUS_REWARD_EXCHANGE_PATH = "exchange/exchange_bonus_reward.csv"
local CONSTELLATION_CONFIG_PATH = "mapping/zodiac_mapping_config.csv"
local CONSTELLATION_REWARD_PATH = "mapping/mapping_reward_rate.csv"
local CONSTELLATION_POINT_POSITION_PATH = "csv/client/zodiac/constellation_point_position.csv"
local CONSTELLATION_FINAL_REWARD_PATH = "mapping/final_mapping_reward.csv"
local CONSTELLATION_FINAL_REWARD_RATE_PATH = "mapping/mapping_reward_rate.csv"

--- @class EventZodiacConfig
EventZodiacConfig = Class(EventZodiacConfig)
function EventZodiacConfig:Ctor(path)
	self.path = path

	--- @type Dictionary
	self.collectionQuestDict = nil

	--- @type Dictionary
	self.exchangeRewardDict = nil

	--- @type Dictionary
	self.constellationConfigDict = nil

	--- @type Dictionary
	self.constellationRewardDict = nil

	--- @type Dictionary
	self.constellationPointDict = nil

	--- @type List
	self.listBonusExchangeReward = nil

	--- @type number
	self.freeOpenStarAmount = nil

	--- @type number
	self.constellationMapAmount = nil

	--- @type number
	self.maxStarAmount = nil

	--- @type number
	self.costStarAmount = nil

	self:GetConstellationConfig()
end

--- @return Dictionary
function EventZodiacConfig:GetCollectionQuestConfig()
	if self.collectionQuestDict == nil then
		local path = string.format("%s/%s", self.path, COLLECTION_QUEST_PATH)
		self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
	end
	return self.collectionQuestDict
end


function EventZodiacConfig:GetListRewardConstellation()
	---@type List
	self.listReward = List()
	local path = string.format("%s/%s", self.path, CONSTELLATION_REWARD_PATH)
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
		local rate = tonumber(parsedData[i].rate)
		if rewardInBound.itemId == MoneyType.STAR_POINT and rate == 0 then
			rewardInBound.rate = MathUtils.RoundDecimal(100,2)
		else
			rewardInBound.rate = MathUtils.RoundDecimal(tonumber(parsedData[i].rate) / totalRate * 100,2)
		end
		self.listReward:Add(rewardInBound)
	end
	return self.listReward
end

function EventZodiacConfig:GetListFinalRewardConstellation()
	---@type List
	self.listReward = List()
	local path = string.format("%s/%s", self.path,CONSTELLATION_FINAL_REWARD_PATH)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	local totalRate = 0
	for i = 1, #parsedData do
		totalRate = totalRate + tonumber(parsedData[i].rate)
	end
	for i = 1, #parsedData do
		--- @type RewardInBound
		local rewardInBound = RewardInBound.CreateByParams(parsedData[i]):GetIconData()
		if tonumber(parsedData[i].rate) == 0 then
			rewardInBound.rate = MathUtils.RoundDecimal(100,2)
		else
			rewardInBound.rate = MathUtils.RoundDecimal(tonumber(parsedData[i].rate) / totalRate * 100,2)
		end
		self.listReward:Add(rewardInBound)
	end
	return self.listReward
end



--- @return Dictionary
function EventZodiacConfig:GetExchangeRewardConfig()
	if self.exchangeRewardDict == nil then
		self.exchangeRewardDict = Dictionary()
		local path = string.format("%s/%s", self.path, EXCHANGE_PATH)
		local data = CsvReaderUtils.ReadAndParseLocalFile(path)
		--- @type List
		local listReward ;
		for i = 1, #data do
			local parse = data[i]
			if parse.stage_id  ~= nil then
				listReward = List()
				self.exchangeRewardDict:Add(tonumber(parse.stage_id),listReward)
				listReward:Add(ZodiacExchangeItemData.CreateByParams(parse))
			else
				listReward:Add(ZodiacExchangeItemData.CreateByParams(parse))
			end
		end
	end
	return self.exchangeRewardDict
end

--- @return Dictionary
function EventZodiacConfig:GetConstellationConfig()
	if self.constellationConfigDict == nil then
		self.constellationConfigDict = Dictionary()
		local path = string.format("%s/%s", self.path, CONSTELLATION_CONFIG_PATH)
		local data = CsvReaderUtils.ReadAndParseLocalFile(path)
		for i = 1, #data do
			local parse = data[i]
			self.openMoneyType = tonumber(parse.open_money_type)
			self.freeOpenStarAmount = tonumber(parse.number_open_free)
			self.constellationMapAmount = tonumber(parse.position_number)
			self.costStarAmount = tonumber(parse.open_money_value)
		end
	end
end


--- @return Dictionary
function EventZodiacConfig:GetConstellationRewardConfig()
	if self.constellationRewardDict == nil then
		self.constellationRewardDict = Dictionary()
		local path = string.format("%s/%s", self.path, CONSTELLATION_REWARD_PATH)
		local data = CsvReaderUtils.ReadAndParseLocalFile(path)
		for i = 1, #data do
			local parse = data[i]
			if parse.id ~= nil then
				local reward = RewardInBound.CreateByParams(data)
				self.constellationRewardDict:Add(tonumber(parse.id), reward)
			end
		end
	end
	return self.constellationRewardDict
end


--- @return Dictionary
function EventZodiacConfig:GetConstellationPointPositionConfig()
	if self.constellationPointDict == nil then
		self.constellationPointDict = Dictionary()
		local data = CsvReaderUtils.ReadAndParseLocalFile(CONSTELLATION_POINT_POSITION_PATH)
		--- @type List
		local listPos = List()
		for i = 1, #data do
			local parseX = data[i]
			if parseX.id ~= nil then
				local parseY = data[i + 1]
				listPos = List()
				self.constellationPointDict:Add(tonumber(parseX.id), listPos)
				for i = 1, 10 do
					listPos:Add(U_Vector2(tonumber(parseX["pos_"..i]), tonumber(parseY["pos_"..i])))
				end
			end
		end
	end
	return self.constellationPointDict
end

--- @return RewardInBound
function EventZodiacConfig:GetBonusRewardById(id)
	if self.listBonusExchangeReward == nil then
		self.listBonusExchangeReward = List()
		local path = string.format("%s/%s", self.path, BONUS_REWARD_EXCHANGE_PATH)
		local data =  CsvReaderUtils.ReadAndParseLocalFile(path)
		for i = 1, #data do
			print("data[i] " , LogUtils.ToDetail(data[i]))
			self.listBonusExchangeReward:Add(RewardInBound.CreateByParams(data[i]))
		end
	end
	print("GetBonusRewardById",LogUtils.ToDetail(self.listBonusExchangeReward:GetItems()))
	return self.listBonusExchangeReward:Get(id)
end



return EventZodiacConfig