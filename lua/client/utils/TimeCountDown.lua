--- @class TimeCountDown
TimeCountDown = Class(TimeCountDown)

--- @return void
---@param finish function
---@param updateText function(time, isSetTime)
function TimeCountDown:Ctor(updateText, finish)
    --- @param isSetTime boolean
    self.updateTime = function (isSetTime)
        if isSetTime == false then
            self.timeFinish = self.timeFinish - 1
        end
        if self.timeFinish > 0 then
            updateText(self.timeFinish, isSetTime)
        else
            self:StopTime()
            if finish ~= nil then
                finish()
            end
        end
    end
    self.isStarting = false
end

--- @return void
function TimeCountDown:StartTime(time)
    if self.isStarting == true then
        self:StopTime()
    end
    self:StopTime()
    self.timeFinish = time
    self.isStarting = true
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

--- @return void
function TimeCountDown:StopTime()
    if self.isStarting == true then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.isStarting = false
    end
end