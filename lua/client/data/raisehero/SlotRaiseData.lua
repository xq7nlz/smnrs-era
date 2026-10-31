--- @class SlotRaiseData
SlotRaiseData = Class(SlotRaiseData)

function SlotRaiseData:Ctor(data)
    self.intervalTime = tonumber(data["interval_time"])
    self.rewardInbound = RewardInBound.CreateBySingleParam(ResourceType.Money, data["money_type"], data["money_value"])
end

return SlotRaiseData