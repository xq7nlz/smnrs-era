require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.Dice.EasterEggExchangeReward.EasterEggExchangeRewardConfig"
local LOGIN_PATH = "login_reward.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"
local ACCUMULATE_QUEST_PATH = "point_quest.csv"
local BONUS_MISSION_BUNDLE_REWARD_PATH = "bundle_config.csv"
local DICE_GAME_PATH = "dice_game/dice_game_config.csv"
local REQUIRE_PATH = "dice_game/dice_config.csv"
local LAP_PATH = "dice_game/lap_quest.csv"
local SILVER_PATH = "egg_rate/egg_silver_rate.csv"
local YELLOW_PATH = "egg_rate/egg_yellow_rate.csv"
local RAINBOW_PATH = "egg_rate/egg_rainbow_rate.csv"
local POINT_REWARD = "point_reward.csv"
--- @class BreakEggPrice
BreakEggPrice = Class(BreakEggPrice)

function BreakEggPrice:Ctor(data)
	if data ~= nil then
		self.moneyType = tonumber(data.money_type)
		self.moneyValue = tonumber(data.money_value)
	end
end

--- @class EventEasterEggConfig
EventEasterEggConfig = Class(EventEasterEggConfig)

function EventEasterEggConfig:Ctor(path)
	self.path = path
	--- @type Dictionary
	self.dailyQuestDict = nil
	--- @type Dictionary
	self.accumulateQuestDict = nil
	--- @type Dictionary
	self._bonusBundleRewardDict = Dictionary()
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventEasterEggConfig:GetQuestConfig()
	if self.dailyQuestDict == nil then
		self.dailyQuestDict = self:InitQuest(DAILY_QUEST_PATH)
	end
	return self.dailyQuestDict
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventEasterEggConfig:GetAccumulateQuestConfig()
	if self.accumulateQuestDict == nil then
		self.accumulateQuestDict = self:InitQuest(ACCUMULATE_QUEST_PATH)
	end
	return self.accumulateQuestDict
end

--- @return Dictionary
function EventEasterEggConfig:InitQuest(path)
	local path = string.format("%s/%s", self.path, path)
	return QuestElementConfig.ReadQuestConfigFromPath(path)
end

--- @return Dictionary
function EventEasterEggConfig:GetLoginConfig()
	local path = string.format("%s/%s", self.path, LOGIN_PATH)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end
	if self.loginRewardDict == nil then
		local listReward = nil
		-- Dictionary(page, Dictionary(day, List<RewardInBound>)
		self.pageDict = Dictionary()
		self.loginRewardDict = Dictionary()
		local isReclaim = parsedData[1].is_reclaim
		if isReclaim ~= nil then
			self.isReclaim = MathUtils.ToBoolean(isReclaim)
		end
		local page = 1
		local loginDataConfig = nil
		for i = 1, #parsedData do
			local day = parsedData[i].day
			if day == nil then
				loginDataConfig.rewardList:Add(RewardInBound.CreateByParams(parsedData[i]))
			else
				day = tonumber(parsedData[i].day)
				listReward = List()
				listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
				local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value)
				loginDataConfig = EventXmasLoginDataConfig(listReward, rewardInBound)
				self.loginRewardDict:Add(day, loginDataConfig)
				if day % 7 == 0 then
					self.pageDict:Add(page, self.loginRewardDict)
					page = page + 1
					self.loginRewardDict = Dictionary()
				end
			end
		end
	end
	return self.pageDict
end

--- @return Dictionary
function EventEasterEggConfig:IsNewLogin()
	if self.isReclaim == nil then
		return false
	end
	return self.isReclaim
end

--- @return List
function EventEasterEggConfig:GetListExchangeConfig()
	if self.listExchange == nil then
		local path = string.format("%s/%s", self.path, "exchange_egg.csv")
		require "lua.client.data.Event.ExchangeEventConfig"
		self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
	end
	return self.listExchange
end

function EventEasterEggConfig:GetBreakEggPrice(index)
	if self.breakEggPriceList == nil then
		---@type List
		self.breakEggPriceList = List()
		local path = string.format("%s/%s", self.path, "break_egg_config.csv")
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		for i = 1, #parsedData do
			self.breakEggPriceList:Add(BreakEggPrice(parsedData[i]))
		end
	end
	return self.breakEggPriceList:Get(index)
end

function EventEasterEggConfig:GetListRewardEgg(eggType)
		local path = nil
		if eggType == EggType.Silver then
			path = SILVER_PATH
		elseif eggType == EggType.Yellow then
			path = YELLOW_PATH
		elseif eggType == EggType.Rainbow then
			path = RAINBOW_PATH
		end
		---@type List
		self.listRewardEggSilver = List()
		local path = string.format("%s/%s", self.path, path)
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
			self.listRewardEggSilver:Add(rewardInBound)
		end
	return self.listRewardEggSilver
end


--- @return List --- List<RewardInBound>()
function EventEasterEggConfig:GetBundleBonusReward(dataId, bundleId)
	if self._bonusBundleRewardDict:IsContainKey(dataId) == false then
		self:_ReadBonusRewardData(dataId)
	end
	--- @type Dictionary
	local rewardDict = self._bonusBundleRewardDict:Get(dataId)
	if rewardDict:IsContainKey(bundleId) then
		return rewardDict:Get(bundleId)
	else
		print("bundleId not found |", "android_package_name: ", bundleId)
	end
	return List()
end

function EventEasterEggConfig:_ReadBonusRewardData(dataId)
	local rewardDict = Dictionary()
	local path = string.format("%s/%s", self.path, BONUS_MISSION_BUNDLE_REWARD_PATH)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	local listReward = List()
	local bundleId
	for i = 1, #parsedData do
		if parsedData[i].android_package_name ~= nil then
			listReward = List()
			bundleId = string.sub(parsedData[i].android_package_name, string.len(parsedData[i].android_package_name)  - 25, string.len(parsedData[i].android_package_name))
			rewardDict:Add(bundleId, listReward)
		end
		local rewardInBound = RewardInBound.CreateByParams(parsedData[i])
		listReward:Add(rewardInBound)
	end
	self._bonusBundleRewardDict:Add(dataId, rewardDict)
end

---@return Dictionary
function EventEasterEggConfig:GetDiceConfig()
	local path = string.format("%s/%s", self.path, DICE_GAME_PATH)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end
	if self.diceRewardInboundDict == nil then
		local listReward = List()
		self.diceRewardInboundDict = Dictionary()
		for i = 1, #parsedData do
			local position = parsedData[i].position
			if position == nil then
				listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
			else
				--day = tonumber(parsedData[i].day)
				position = tonumber(position) + 1
				listReward = List()
				if parsedData[i].res_id ~= nil then
					listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
				end
				self.diceRewardInboundDict:Add(position, listReward)
			end
		end
	end
	return self.diceRewardInboundDict
end

function EventEasterEggConfig:GetRollRequireConfig()
	local path = string.format("%s/%s", self.path, REQUIRE_PATH)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end
	if self.requireList == nil then
		self.requireList = List()
		for i = 1, #parsedData do
			self.requireList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value))
		end
	end
	return self.requireList
end

---@return Dictionary
function EventEasterEggConfig:GetLapConfig()
	local path = string.format("%s/%s", self.path, LAP_PATH)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end
	if self.lapRewardInboundDict == nil then
		---@type EventHalloweenLapDataConfig
		local lapConfig = nil
		self.lapRewardInboundDict = Dictionary()
		for i = 1, #parsedData do
			local questId = parsedData[i].quest_id
			if questId == nil then
				lapConfig.rewardList:Add(RewardInBound.CreateByParams(parsedData[i]))
			else
				questId = tonumber(questId)

				local listReward = List()

				listReward:Add(RewardInBound.CreateByParams(parsedData[i]))

				local lapRequire = tonumber(parsedData[i].requirement_1)
				local lapConfig = EventHalloweenLapDataConfig(lapRequire, listReward)
				self.lapRewardInboundDict:Add(questId, lapConfig)
			end
		end
	end
	return self.lapRewardInboundDict
end

---@return Dictionary
function EventEasterEggConfig:GetQuestId(lapCompleted)
	---@param v EventHalloweenLapDataConfig
	for i, v in pairs(self.lapRewardInboundDict:GetItems()) do
		if lapCompleted < v:GetLapRequire() then
			return i - 1
		end
	end
	return self.lapRewardInboundDict:Count()
end

--- @return List
function EventEasterEggConfig:GetListRewardExchangeConfig()
	if self._listReward == nil then
		local path = string.format("%s/%s", self.path, POINT_REWARD)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		self._listReward = List()
		--- @type EasterEggExchangeRewardConfig
		local questConfig
		for i = 1, #parsedData do
			local id = parsedData[i].id
			if id ~= nil then
				questConfig = EasterEggExchangeRewardConfig()
				questConfig.id = tonumber(id)
				questConfig.type = tonumber(parsedData[i].money_type)
				questConfig.price = tonumber(parsedData[i].money_value)
				self._listReward:Add(questConfig)
				local isSelectionReward = parsedData[i].is_selection_reward
				if isSelectionReward ~= nil then
					questConfig.isSelectionReward = MathUtils.ToBoolean(isSelectionReward)
					if (questConfig.isSelectionReward == true) then
						---@type number
						local selection_id = tonumber(parsedData[i]['selection_id'])
						---@type ResourceType
						local selection_res_type = parsedData[i]['selection_res_type']
						---@type number
						local selection_res_id = parsedData[i]['selection_res_id']
						---@type number
						local selection_res_number = parsedData[i]['selection_res_number']
						--- @type number
						local selection_res_data = parsedData[i]['selection_res_data']
						---@type SelectReward
						local selectReward = SelectReward()
						---@type RewardInBound
						local rewardInBound = RewardInBound.CreateBySingleParam(selection_res_type,
								selection_res_id, selection_res_number, selection_res_data)
						selectReward.rewardInBound = rewardInBound
						selectReward.selectionId = selection_id
						questConfig:AddSelectionResData(selection_id,selectReward)
					end
				end
				questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))

			else
				if (questConfig.isSelectionReward == true) then
					---@type number
					local selection_id = tonumber(parsedData[i]['selection_id'])
					---@type ResourceType
					local selection_res_type = parsedData[i]['selection_res_type']
					---@type number
					local selection_res_id = parsedData[i]['selection_res_id']
					---@type number
					local selection_res_number = parsedData[i]['selection_res_number']
					--- @type number
					local selection_res_data = parsedData[i]['selection_res_data']
					---@type SelectReward
					local selectReward = SelectReward()
					---@type RewardInBound
					local rewardInBound = RewardInBound.CreateBySingleParam(selection_res_type,
							selection_res_id, selection_res_number, selection_res_data)
					selectReward.rewardInBound = rewardInBound
					selectReward.selectionId = selection_id
					questConfig.isSelectionReward = true
					questConfig:AddSelectionResData(selection_id,selectReward)
				else
					questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
				end
			end
		end
	end
	return self._listReward
end
--- @type EasterEggExchangeRewardConfig
function EventEasterEggConfig:GetPoolReward(id)
	return self._listReward:Get(id)
end

EggType = {
	Silver = 1,
	Yellow = 2,
	Rainbow = 3
}