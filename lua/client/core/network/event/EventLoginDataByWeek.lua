--- @class EventLoginDataByWeek : EventLoginData
EventLoginDataByWeek = Class(EventLoginDataByWeek,EventLoginData)

--- @param buffer UnifiedNetwork_ByteBuf
function EventLoginDataByWeek:Ctor(buffer,week)
    if buffer then
        self:ReadBuffer(buffer)
    end
    self.week = week
end

function EventLoginDataByWeek:IsClaimed()
    local startTimeOfDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
    return self.lastClaimDay >= TimeUtils.DayAWeek * self.week
            or self.lastClaimDay > self.eventCurrentDay
            or (self.lastClaimDay == self.eventCurrentDay and startTimeOfDay <= self.lastClaimLoginTime)
end

function EventLoginDataByWeek:IsFreeClaim()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
            or self.lastClaimDay >= TimeUtils.DayAWeek * self.week
end