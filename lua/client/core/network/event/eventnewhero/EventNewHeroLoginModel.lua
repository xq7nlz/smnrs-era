--- @class EventNewHeroLoginModel : EventPopupModel
EventNewHeroLoginModel = Class(EventNewHeroLoginModel, EventPopupModel)

function EventNewHeroLoginModel:Ctor()
    --- @type EventLoginData
    self.eventLoginData = nil
    EventPopupModel.Ctor(self)
end

function EventNewHeroLoginModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventNewHeroLoginModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventNewHeroLoginModel:ReadInnerData(buffer)
    self.eventLoginData = EventLoginData(buffer)
end

function EventNewHeroLoginModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewHeroLoginModel:IsClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsClaimed()
    end
    return nil
end

function EventNewHeroLoginModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventNewHeroLoginModel:GetLoginData()
    return self.eventLoginData
end


function EventNewHeroLoginModel:HasNotification()
    return self:IsDailyLoginHasNotification()
end