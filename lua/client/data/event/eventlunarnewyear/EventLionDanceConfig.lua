--- @class EventLionDanceConfig
EventLionDanceConfig = Class(EventLionDanceConfig)

function EventLionDanceConfig:Ctor(path)
	self.path = path
	--- @type List
	self._listQuestConfig = nil
	--- @type List
	self._listInstanceReward = nil
end

--- @return List
function EventLionDanceConfig:GetListQuestConfig()
	if self._listQuestConfig == nil then
		local path = string.format("%s/%s", self.path, "lion_dance_quest.csv")
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
						local rewardInBound = RewardInBound.CreateBySingleParam(selection_res_type, selection_res_id, selection_res_number, selection_res_data)
						selectReward.rewardInBound = rewardInBound
						selectReward.selectionId = selection_id
						questConfig:AddSelectionResData(selection_id,selectReward)
					end
				end
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
					local rewardInBound = RewardInBound.CreateBySingleParam(selection_res_type, selection_res_id, selection_res_number, selection_res_data)
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
	return self._listQuestConfig
end

--- @return List
function EventLionDanceConfig:GetListInstanceReward()
	return self._listInstanceReward
end