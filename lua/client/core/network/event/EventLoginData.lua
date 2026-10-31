--- @class EventLoginData
EventLoginData = Class(EventLoginData)

--- @param buffer UnifiedNetwork_ByteBuf
function EventLoginData:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventLoginData:ReadBuffer(buffer)
    self.lastClaimDay = buffer:GetInt()
    self.eventCurrentDay = buffer:GetInt()
    self.lastClaimLoginTime = buffer:GetLong()
end

function EventLoginData:IsClaimed()
    local startTimeOfDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
    return self.lastClaimDay >= TimeUtils.DayAWeek
            or self.lastClaimDay > self.eventCurrentDay
            or (self.lastClaimDay == self.eventCurrentDay and startTimeOfDay <= self.lastClaimLoginTime)
end

function EventLoginData:IsFreeClaim()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
            or self.lastClaimDay >= 7
end

function EventLoginData:IsFreeClaimNew()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) >= self.lastClaimLoginTime
            or self.lastClaimDay >= 7
end