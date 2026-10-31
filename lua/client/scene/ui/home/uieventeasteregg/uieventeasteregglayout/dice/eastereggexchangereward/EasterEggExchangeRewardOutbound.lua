--- @class EasterEggExchangeRewardOutbound : OutBound
EasterEggExchangeRewardOutbound = Class(EasterEggExchangeRewardOutbound, OutBound)

--- @return void
function EasterEggExchangeRewardOutbound:Ctor()
	--- @type number
	self.number = 0
	---@type number
	self.rewardId= nil
	---@type Dictionary
	self.selectedDict = Dictionary()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EasterEggExchangeRewardOutbound:Serialize(buffer)
	buffer:PutInt(self.number)
	buffer:PutInt(self.rewardId)
	buffer:PutInt(self.selectedDict:Count())
	for key,value in pairs(self.selectedDict:GetItems()) do
		buffer:PutInt(self.key)
		buffer:PutInt(self.value)
	end
end