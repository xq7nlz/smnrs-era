--- @class EventNewServerWeekSpinModel : EventPopupModel
EventNewServerWeekSpinModel = Class(EventNewServerWeekSpinModel, EventPopupModel)

function EventNewServerWeekSpinModel:Ctor()
    ---@type number
    self.nextSpinTime = -1
    ---@type number
    self.numberSpined = nil
   ---@type EventNewServerWeekSpinConfig
    self.eventConfig = nil
    ---@type number
    self.lastSpinTime = nil
    --- @type List -- number
    self.openedPositions = List() -- count from
    EventPopupModel.Ctor(self)
end

function EventNewServerWeekSpinModel:HasNotification()
    self:GetConfig()
    self:CalculateSpinInfo()
    return self:AvailableToSpin()
end

function EventNewServerWeekSpinModel:AddOpenedPosition(pos)
    self.openedPositions:Add(pos)
    self.numberSpined = self.openedPositions:Count()
   -- XDebug.Log("ADD POS fake " .. tostring(pos) .. " count" .. tostring(self.numberSpined))
end

function EventNewServerWeekSpinModel:SetLastSpintTime(_time)
    self.lastSpinTime = _time
    --XDebug.Log("LAST SPIN TIME SET " .. tostring(self.lastSpinTime))
    self:UpdateSpinTime()
end

function EventNewServerWeekSpinModel:CalculateSpinInfo()
    self.numberSpined = self.openedPositions:Count()
    self:UpdateSpinTime()
end

function EventNewServerWeekSpinModel:UpdateSpinTime() --ALL
    self:GetNextSpinTime()
end

function EventNewServerWeekSpinModel:NotNeedNextSpinTimeCountDown()
    return self:ReachMaxSpinNumber() or self:NextSpinTimeAvailable()
end

function EventNewServerWeekSpinModel:ReachMaxSpinNumberNextSpin(numberSpined)
    return numberSpined > self:GetConfig().dictSpinCooldown:Count()
end


function EventNewServerWeekSpinModel:ReachMaxSpinNumber()
    return self.numberSpined >= self:GetConfig().dictSpinCooldown:Count()
end

function EventNewServerWeekSpinModel:NextSpinTimeAvailable()
   -- print("hoang pl next spin time " , self.nextSpinTime , " current time " , zg.timeMgr:GetServerTime())
   return self.nextSpinTime <= zg.timeMgr:GetServerTime()
end

---@return boolean
function EventNewServerWeekSpinModel:AvailableToSpin(spinTimeAvailable)
    return (not self:ReachMaxSpinNumber()) and (spinTimeAvailable or self:NextSpinTimeAvailable())
end

---@type number
function EventNewServerWeekSpinModel:GetNextSpinTime()
    self.numberSpined = self.openedPositions:Count()
    --print("number reward claimed " ,  self.numberSpined)
    self.nextSpinTime =  self.lastSpinTime + self:GetTimeCooldown()
    --XDebug.Log("LAST SPINTIME " .. tostring(self.lastSpinTime) .. "cooldown time " .. tostring(self:GetTimeCooldown()))
--[[    if (self.numberSpined == 0) then
        self.nextSpinTime = -1
        else

    end]]
    return self.nextSpinTime
end

function EventNewServerWeekSpinModel:GetTimeCooldownForSpinNumber(numberSpined)

    self:GetConfig()
    ---@type number
    local time = self.eventConfig:GetDictSpinCooldownTime():Get(numberSpined + 1)
    if (time == nil) then
        return 0
    end
    return time
end

function EventNewServerWeekSpinModel:GetTimeCooldown()
    self.numberSpined = self.openedPositions:Count()
    self:GetConfig()
    ---@type number
    local time = self.eventConfig:GetDictSpinCooldownTime():Get(self.numberSpined + 1)
    if (time == nil) then
        return 0
    end
    return time
end

function EventNewServerWeekSpinModel:ReadInnerData(buffer)
    self.lastSpinTime = buffer:GetLong()
    ---@type number
    local size = buffer:GetByte()
    self.numberSpined = size
    if (size > 0) then
        self.openedPositions = List()
        for i = 1, size do
            local position = buffer:GetInt()
            --XDebug.Log("ADD POS buffer " .. tostring(position))
            self.openedPositions:Add(position)
        end
    end
end


--- @return EventNewServerWeekSpinConfig
function EventNewServerWeekSpinModel:GetConfig()
    self.eventConfig = EventPopupModel.GetConfig(self)
    return self.eventConfig
end