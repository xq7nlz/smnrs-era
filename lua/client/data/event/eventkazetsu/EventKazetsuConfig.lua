local PITY_CONFIG = "pity_config.csv"
local SUMMON_PRICE = "summon_price.csv"
local SUMMON_QUEST = "summon_quest.csv"
local LOGIN_REWARD = "login_reward.csv"
local KAZETSU_GIFT = "kazetsu_collection.csv"
local DAILY_QUEST = "daily_quest/daily_quest_reward.csv"
local DEFENDER_TEAM = "kazetsu_trial/defender_team.csv"
local DEFENDER_TEAM_FINAL = "kazetsu_trial/defender_team_final.csv"
local TRIAL_HERO_STAT = "kazetsu_trial/trial_hero_stat.csv"
local TRIAL_CONFIG = "kazetsu_trial/kazetsu_trial_config.csv"
local LEADER_BOSS_CONFIG = "kazetsu_boss/leader_board_reward.csv"

--- @class EventKazetsuConfig
EventKazetsuConfig = Class(EventKazetsuConfig)

function EventKazetsuConfig:Ctor(path)
	self.path = path
	--- @type Dictionary
	self.dictLineUpRecommend = Dictionary()
	--- @type table
	self.priceRateUp = nil
	--- @type Dictionary
	self.dictHeroSelected = Dictionary()

	--- @type table {gemReset, gemRefresh, poolNumberHero, gemRevive, revivePerDay}
	self.trialConfig = nil
end

--- @return Dictionary
function EventKazetsuConfig:GetLoginConfig()
	local path = string.format("%s/%s", self.path, LOGIN_REWARD)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end
	if self.loginRewardDict == nil then
		local listReward = nil
		self.loginRewardDict = Dictionary()
		for i = 1, #parsedData do
			local day = parsedData[i].day
			if day == nil then
				listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
			else
				day = tonumber(parsedData[i].day)
				listReward = List()
				listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
				self.loginRewardDict:Add(day, listReward)
			end
		end
	end
	return self.loginRewardDict
end

--- @return List
function EventKazetsuConfig:GetListKazetsuGiftQuestConfig()
	if self._listQuestConfig == nil then
		local path = string.format("%s/%s", self.path, KAZETSU_GIFT)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		self._listQuestConfig = List()
		--- @type QuestElementConfig
		local questConfig
		for i = 1, #parsedData do
			local questId = parsedData[i].quest_id
			if questId ~= nil then
				questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
				self._listQuestConfig:Add(questConfig)
			else
				questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
			end
		end
	end
	return self._listQuestConfig
end

--- @return List
function EventKazetsuConfig:GetListKazetsuSummonQuestConfig()
	if self._listSummonQuestConfig == nil then
		local path = string.format("%s/%s", self.path, SUMMON_QUEST)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		self._listSummonQuestConfig = List()
		--- @type QuestElementConfig
		local questConfig
		for i = 1, #parsedData do
			local questId = parsedData[i].quest_id
			if questId ~= nil then
				questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
				self._listSummonQuestConfig:Add(questConfig)
			else
				questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
			end
		end
	end
	return self._listSummonQuestConfig
end

--- @return List
function EventKazetsuConfig:GetFirstListKazetsuSummonQuestConfig()
	if self.listSummonQuestConfig == nil then
		local path = string.format("%s/%s", self.path, SUMMON_QUEST)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		self.listSummonQuestConfig = List()
		--- @type QuestElementConfig
		local questConfig
		for i = 1, #parsedData do
			if i < 6 then
				local questId = parsedData[i].quest_id
				if questId ~= nil then
					questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
					self.listSummonQuestConfig:Add(questConfig)
				else
					questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
				end
			end
		end
	end
	return self.listSummonQuestConfig
end

--- @return List
function EventKazetsuConfig:GetListKazetsuDailyQuestConfig()
	if self._listDailyQuestConfig == nil then
		local path = string.format("%s/%s", self.path, DAILY_QUEST)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		self._listDailyQuestConfig = List()
		--- @type QuestElementConfig
		local questConfig
		for i = 1, #parsedData do
			local questId = parsedData[i].quest_id
			if questId ~= nil then
				questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
				self._listDailyQuestConfig:Add(questConfig)
			else
				questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
			end
		end
	end
	return self._listDailyQuestConfig
end

--- @return EventValentineBossChallengeConfig
function EventKazetsuConfig:GetBossChallengeConfig()
	if self.eventValentineBossChallengeConfig == nil then
		require "lua.client.data.Event.EventKazetsu.EventKazetsuBossChallengeConfig"
		self.eventValentineBossChallengeConfig = EventKazetsuBossChallengeConfig(self.path)
	end
	return self.eventValentineBossChallengeConfig
end

--- @class EventKazetsuPityData
EventKazetsuPityData = Class(EventKazetsuPityData)
function EventKazetsuPityData:Ctor(data)
	self.heroId = tonumber(data['hero_id'])
	self.summonPoint = tonumber(data['summon_point'])
	self.pityAccumulationPoint = tonumber(data['pity_accumulation_point'])
	self.pityEnable = MathUtils.ToBoolean(data['is_active'])
end

--- @return EventPityData
function EventKazetsuConfig:GetPityConfig()
	if self.eventPityConfig == nil then
		local path = string.format("%s/%s", self.path, PITY_CONFIG)
		local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
		self.eventPityConfig = EventKazetsuPityData(dataParse[1])
	end
	return self.eventPityConfig
end

--- @return table
--- @param type number
--- @param quantity number
function EventKazetsuConfig:GetInfoRateUp(type, quantity)
	return self.priceRateUp[type][quantity]
end
--- @return number
--- @param quantity number
function EventKazetsuConfig:GetSummonRateUpPrice(summonType, quantity)
	if self.priceRateUp == nil then
		self.priceRateUp = {}
		local path = string.format("%s/%s", self.path, SUMMON_PRICE)
		local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
		for _, data in ipairs(dataParse) do
			local summonType = tonumber(data['summon_type'])
			self.priceRateUp[summonType] = self.priceRateUp[summonType] or {}
			local summonNumber = tonumber(data['summon_number'])
			self.priceRateUp[summonType][summonNumber] = HeroSummonPrice(data)
		end
	end
	return self:GetInfoRateUp(summonType, quantity)
end

---@return List --<QuestElementConfig>
function EventKazetsuConfig:GetListSummonBonusQuest()
	if self.listQuest == nil then
		local path = string.format("%s/%s", self.path, SUMMON_QUEST)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		--- @type List
		self.listQuest = List()
		--- @type QuestElementConfig
		local questConfig
		for i = 1, #parsedData do
			local questId = parsedData[i].quest_id
			if questId ~= nil then
				questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
				self.listQuest:Add(questConfig)
			else
				questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
			end
		end
	end
	return self.listQuest
end

---@return List --<QuestElementConfig>
function EventKazetsuConfig:GetListSummonBonusQuest()
	if self.listQuest == nil then
		local path = string.format("%s/%s", self.path, SUMMON_QUEST)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end
		--- @type List
		self.listQuest = List()
		--- @type QuestElementConfig
		local questConfig
		for i = 1, #parsedData do
			local questId = parsedData[i].quest_id
			if questId ~= nil then
				questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
				self.listQuest:Add(questConfig)
			else
				questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
			end
		end
	end
	return self.listQuest
end

function EventKazetsuConfig:_InitKazetsuTowerConfig()
	local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
	local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(path)
	require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuTrail.KazetsuTowerConfig"
	self.campaignStageConfig = KazetsuTowerConfig()
	self.campaignStageConfig:ParseCsv(levelDesignContent)
end

--- @return DefenderTeamData
--- @param stageId number
function EventKazetsuConfig:GetCampaignStageConfigById(stageId)
	if self.campaignStageConfig == nil then
		self:_InitKazetsuTowerConfig()
	end
	return self.campaignStageConfig:GetCampaignStageConfigById(stageId)
end

--- @return DefenderTeamData
--- @param stageId number
function EventKazetsuConfig:GetTotalKazetsuTower()
	if self.campaignStageConfig == nil then
		self:_InitKazetsuTowerConfig()
	end
	return self.campaignStageConfig:GetTotalTower()
end

--- @return List<ItemIconData>
--- @param stageId number
function EventKazetsuConfig:GetTowerRewardById(stageId)
	if self.kazetsuTowerRewardConfig == nil then
		require "lua.client.data.Event.EventKazetsu.KazetsuTowerRewardConfig"
		self.kazetsuTowerRewardConfig = KazetsuTowerRewardConfig()
	end
	return self.kazetsuTowerRewardConfig:GetReward(stageId)
end

--- @return BattleTeamInfo
function EventKazetsuConfig:GetListLineupRecommendation(id)
	if self.dictLineUpRecommend:Count() == 0 then
		local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
		local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
		for _, data in pairs(dataParse) do
			if data.stage ~= nil then
				local predefineTeam = PredefineTeamData.CreateByCsv(data)
				---@type BattleTeamInfo
				local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
				if lineupTeam ~= nil then
					self.dictLineUpRecommend:Add(tonumber(data.stage), lineupTeam)
				end
			end
		end
	end
	local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
	local recentTime = eventModel.timeData.endTime - zg.timeMgr:GetServerTime()
	local isLastDay = recentTime <= TimeUtils.SecondADay
	if isLastDay and id == 15 then
		local path = string.format("%s/%s", self.path, DEFENDER_TEAM_FINAL)
		local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
		for _, data in pairs(dataParse) do
			if data.stage ~= nil then
				if tonumber(data.stage) == 15 then
					local predefineTeam = PredefineTeamData.CreateByCsv(data)
					---@type BattleTeamInfo
					local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
					if lineupTeam ~= nil then
						--self.dictLineUpRecommend:RemoveByKey(tonumber(data.stage))
						--self.dictLineUpRecommend:Add(tonumber(data.stage), lineupTeam)
						return lineupTeam
					end
				end
			end
		end
	end
	return self.dictLineUpRecommend:Get(id)
end

--- @return  number
function EventKazetsuConfig:GetHeroIdAndStar()
	if self.heroId == nil then
		local path = string.format("%s/%s", self.path, SUMMON_PRICE)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		self.heroId = tonumber(parsedData[1].hero_id)
		self.heroStar = tonumber(parsedData[1].hero_star)
	end
	return self.heroId, self.heroStar
end

--- @return  number
function EventKazetsuConfig:GetFreeInterval()
	if self.freeInterval == nil then
		local path = string.format("%s/%s", self.path, SUMMON_PRICE)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		self.freeInterval = tonumber(parsedData[1].free_summon_interval)
	end
	return self.freeInterval
end

--- @return HeroResource
--- @param selectionId number
--- Get HeroResource from csv corresponding with selectionId
function EventKazetsuConfig:GetHeroResourceBySelectionId(selectionId)
	if self.dictHeroSelected:Count() == 0 then
		self:InitHeroResource()
	end
	return self.dictHeroSelected:Get(selectionId);
end

--- @return  table
function EventKazetsuConfig:GetTrialConfig()
	if self.trialConfig == nil then
		local path = string.format("%s/%s", self.path, TRIAL_CONFIG)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		if parsedData == nil then
			XDebug.Error(string.format("Get EventConfig nil %s", path))
			return
		end

		self.trialConfig = {
			["gemReset"] = tonumber(parsedData[1].gem_reset),
			["gemRefresh"] = tonumber(parsedData[1].gem_refresh),
			["poolNumberHero"] = tonumber(parsedData[1].pool_number_hero),
			["gemRevive"] = tonumber(parsedData[1].gem_revive),
			["revivePerDay"] = tonumber(parsedData[1].revive_per_day)
		}
	end
	return self.trialConfig
end

--- @return Dictionary
--- Get HeroResource from csv corresponding with selectionId
function EventKazetsuConfig:GetHeroResource()
	if self.dictHeroSelected:Count() == 0 then
		self:InitHeroResource()
	end
	return self.dictHeroSelected
end

function EventKazetsuConfig:InitHeroResource()
	local path = string.format("%s/%s", self.path, TRIAL_HERO_STAT)
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
	if parsedData == nil then
		XDebug.Error(string.format("Get EventConfig nil %s", path))
		return
	end

	for i = 1, #parsedData do
		local selectId = tonumber(parsedData[i].selection_id);
		if selectId ~= nil then
			local heroId = tonumber(parsedData[i].hero_id);
			local star = tonumber(parsedData[i].star);
			local level = tonumber(parsedData[i].level);
			self.dictHeroSelected:Add(selectId, HeroResource.CreateInstance(selectId, heroId, star, level))
		end
	end
end

--- @return Dictionary
--- @param selectionsId List
--- Get HeroResource from csv corresponding with selectionId
function EventKazetsuConfig:GetHeroResourceByListSelection(selectionsId)
	if self.dictHeroSelected:Count() == 0 then
		self:InitHeroResource()
	end
	--- @type List
	local listHeroResources = List()
	for i = 1, selectionsId:Count() do
		--- @type HeroResource
		local hero = self.dictHeroSelected:Get(selectionsId:Get(i))
		hero.inventoryId = selectionsId:Get(i)
		listHeroResources:Add(hero)
	end
	return listHeroResources
end

function EventKazetsuConfig:GetListRewardByRank(rank)
	self:GetArenaConfigList()
	for i = self.arenaConfigList:Count(), 1, -1 do
		---@type ArenaRewardRankingConfig
		local arenaRewardRankingConfig = self.arenaConfigList:Get(i)
		if (rank >= arenaRewardRankingConfig.topMin) then
			return arenaRewardRankingConfig.listRewardItem
		end
	end

end

--- @return List
function EventKazetsuConfig:GetArenaConfigList()
	if self.arenaConfigList == nil then
		self.arenaConfigList = List()
		local path = string.format("%s/%s", self.path, LEADER_BOSS_CONFIG)
		local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
		local topMin = nil
		local topMax = nil
		local listResourceItems = List()
		---@type ArenaRewardRankingConfig
		local arenaRewardRankingConfig
		for i = 1, #parsedData do
			local lineData = parsedData[i]
			if lineData["min"] ~= nil then
				require "lua.client.data.Arena.ArenaRewardRankingConfig"
				---@type ArenaRewardRankingConfig
				arenaRewardRankingConfig = ArenaRewardRankingConfig()
				self.arenaConfigList:Add(arenaRewardRankingConfig)
				arenaRewardRankingConfig.topMin  = tonumber(lineData["min"])
				arenaRewardRankingConfig.topMax  = tonumber(lineData["max"])
				arenaRewardRankingConfig.listRewardItem = List()
			else

			end
			---@type ItemIconData
			local itemIconData = ItemIconData.CreateInstance(tonumber(lineData["res_type"]), tonumber(lineData["res_id"]), tonumber(lineData["res_number"]))
			arenaRewardRankingConfig.listRewardItem:Add(itemIconData)
		end
	end
	return self.arenaConfigList
end