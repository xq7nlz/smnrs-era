--- @class EventThankGivingLoginData
EventThankGivingLoginData = Class(EventThankGivingLoginData)

function EventThankGivingLoginData:Ctor()
    self.lastClaimDay = nil
    self.eventCurrentDay = nil
    self.lastClaimLoginTime = nil
end
--- @param buffer UnifiedNetwork_ByteBuf
function EventThankGivingLoginData:ReadBuffer(buffer)
    self.lastClaimDay = buffer:GetInt()
    self.eventCurrentDay = buffer:GetInt()
    self.lastClaimLoginTime = buffer:GetLong()
end

function EventThankGivingLoginData:IsClaim()
    return self.lastClaimDay >= 14 or self.lastClaimDay > self.eventCurrentDay or (self.lastClaimDay == self.eventCurrentDay and TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime)
end

function EventThankGivingLoginData:IsFreeClaim()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
            or self.lastClaimDay >= 14
end