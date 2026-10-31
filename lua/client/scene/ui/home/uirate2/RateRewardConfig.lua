local RATING_REWARD_CONFIG_PATH = "csv/rating/rating_reward_config.csv"
--- @class RateRewardConfig
RateRewardConfig = Class(RateRewardConfig)


function RateRewardConfig:Ctor()
	--- @type Dictionary
	self.rewardDict = Dictionary()
	self:GetRatingRewardConfig()
end


function RateRewardConfig:GetRatingRewardConfig()
	if self.rewardDict:Count() < 1  then
		local decodeData = CsvReaderUtils.ReadAndParseLocalFile(RATING_REWARD_CONFIG_PATH)
		--- @type List
		local listReward;
		for _, parsedData in ipairs(decodeData) do
			if parsedData.id ~= nil then
				listReward = List()
				listReward:Add(RewardInBound.CreateBySingleParam(tonumber(parsedData.res_type),
						tonumber(parsedData.res_id),
						tonumber(parsedData.res_number)))
				self.rewardDict:Add(tonumber(parsedData.id),listReward)
			else
				listReward:Add(RewardInBound.CreateBySingleParam(tonumber(parsedData.res_type),
						tonumber(parsedData.res_id),
						tonumber(parsedData.res_number)))
			end
		end
	end
end


--- @return List
function RateRewardConfig:GetLikeReward()
	return self.rewardDict:Get(1)
end
--- @return List
function RateRewardConfig:GetRateReward()
	return self.rewardDict:Get(2)
end