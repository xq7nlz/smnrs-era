--- @class EventRateUpSummonResult
EventRateUpSummonResult = Class(EventRateUpSummonResult, SummonResultInBound)

function EventRateUpSummonResult:Ctor(buffer)
    SummonResultInBound.Ctor(self, buffer)
    self.lastEventRateUpPoint = buffer:GetLong()

    local eventRateUpValueBonus = self.lastEventRateUpPoint - InventoryUtils.GetMoney(MoneyType.EVENT_RATE_UP_SUMMON_POINT)
    InventoryUtils.Add(ResourceType.Money, MoneyType.EVENT_RATE_UP_SUMMON_POINT, eventRateUpValueBonus)
end