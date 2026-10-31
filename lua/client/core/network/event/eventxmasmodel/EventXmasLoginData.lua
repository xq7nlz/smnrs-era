--- @class EventXmasLoginData
EventXmasLoginData = Class(EventXmasLoginData)

function EventXmasLoginData:Ctor()
    self.lastClaimDay = nil
    self.eventCurrentDay = nil
    self.lastClaimLoginTime = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventXmasLoginData:ReadBuffer(buffer)
    self.lastClaimDay = buffer:GetInt()
    self.eventCurrentDay = buffer:GetInt()
    self.lastClaimLoginTime = buffer:GetLong()
end

function EventXmasLoginData:IsClaim()
    return self.lastClaimDay >= 7 or self.lastClaimDay > self.eventCurrentDay or (self.lastClaimDay == self.eventCurrentDay and TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime)
end

function EventXmasLoginData:IsFreeClaim()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
            or self.lastClaimDay >= 7
end