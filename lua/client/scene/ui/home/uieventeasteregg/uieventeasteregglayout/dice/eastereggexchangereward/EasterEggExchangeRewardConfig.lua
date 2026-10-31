--- @class EasterEggExchangeRewardConfig
EasterEggExchangeRewardConfig = Class(EasterEggExchangeRewardConfig)

function EasterEggExchangeRewardConfig:Ctor()
	--- @type number
	self.price = 0
	--- @type number
	self.id = 0
	--- @type number
	self.type = 0
	--- @type List
	self._listReward = nil
	--- @type boolean
	self.isSelectionReward = false
	---@type List
	self.rewardSelectionList = nil
	---@type Dictionary
	self.rewardSelectionItemDict = nil
end

--- @param selectReward SelectReward
function EasterEggExchangeRewardConfig:AddSelectionResData(selectionID,selectReward)
	if self.rewardSelectionList == nil then
		self.rewardSelectionList = List()
	end
	if (self.rewardSelectionItemDict == nil) then
		self.rewardSelectionItemDict = Dictionary()
	end
	self.rewardSelectionList:Add(selectReward)
	self.rewardSelectionItemDict:Add(selectionID,selectReward)
end

--- @param reward RewardInBound
function EasterEggExchangeRewardConfig:AddResData(reward)
	if self._listReward == nil then
		self._listReward = List()
	end
	if reward ~= nil then
		self._listReward:Add(reward)
	end
end
