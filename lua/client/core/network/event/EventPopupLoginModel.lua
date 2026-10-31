--- @class EventPopupLoginModel : EventPopupModel
EventPopupLoginModel = Class(EventPopupLoginModel, EventPopupModel)

--- @param buffer UnifiedNetwork_ByteBuf
function EventPopupLoginModel:ReadInnerData(buffer)
    self.lastDayUserClaim = buffer:GetInt()
    self.lastClaimTime = buffer:GetLong()
end

function EventPopupLoginModel:IsClaim()
    if self.lastClaimTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimTime
                or self.lastDayUserClaim >= 7
    end
    return nil
end

function EventPopupLoginModel:IsAvailableToShowLogin()
    local lastTimeShowLogin = zg.playerData.remoteConfig.lastTimeShowEventLogin
    if lastTimeShowLogin == nil and self:IsClaim() == false then
        return true
    elseif lastTimeShowLogin ~= nil and self:IsClaim() == false then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) > TimeUtils.GetTimeStartDayFromSec(lastTimeShowLogin)
    end
    return false
end

function EventPopupLoginModel:HasNotification()
    return self:IsClaim() == false
end

--- @return Dictionary
function EventPopupLoginModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end