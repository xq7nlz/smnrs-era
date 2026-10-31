--- @class RegenTime
RegenTime = Class(RegenTime)

--- @return void
---@param regenTimeData RegenTimeData
---@param moneyType MoneyType
function RegenTime:Ctor(regenTimeData, moneyType)
    ---@type RegenTimeData
    self.regenTimeData = regenTimeData
    ---@type number
    self.moneyType = moneyType
    ---@type function
    self.onUpdateTime = nil
    ---@type function
    self.onFirstUpdateTime = nil
    ---@type function
    self.onFinishUpdateTime = nil

    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh >= 0 then
            self:UpdateTimeUI()
        else
            RxMgr.changeResource:Next(
                    {['resourceType'] = ResourceType.Money, ['resourceId'] = self.moneyType, ['quantity'] = 0,
                     ['result'] = InventoryUtils.GetMoney(self.moneyType)
                    }
            )
        end
    end
end

--- @return void
function RegenTime:_InitListener()
    if self.listener == nil then
        self.listener = RxMgr.changeResource:Subscribe(function (data)
            if data.resourceType == ResourceType.Money
                and data.resourceId == self.moneyType then
                self:CheckRegenTime()
            end
        end)
    end
end

--- @return void
function RegenTime:_RemoveListener()
    if self.listener ~= nil then
        self.listener:Unsubscribe()
        self.listener = nil
    end
end

function RegenTime:FirstUpdateTimeUI()
    if self.onFirstUpdateTime ~= nil then
        self.onFirstUpdateTime()
    end
end

function RegenTime:UpdateTimeUI()
    if self.onUpdateTime ~= nil then
        self.onUpdateTime(TimeUtils.SecondsToClock(self.timeRefresh))
    end
end

function RegenTime:FinishUpdateTimeUI()
    if self.onFinishUpdateTime ~= nil then
        self.onFinishUpdateTime()
    end
end

function RegenTime:SetTimeRefresh()
    self.timeRefresh = (self.regenTimeData.step - zg.timeMgr:GetServerTime() + self.regenTimeData.getLastRegenTime()) % self.regenTimeData.step + 1
end

--- @return void
function RegenTime:Init()
    self:_InitListener()
    self:CheckRegenTime()
end

--- @return void
function RegenTime:CheckRegenTime()
    if InventoryUtils.GetMoney(self.moneyType) < self.regenTimeData.max then
        self:SetTimeRefresh()
        if self.isRegisterUpdateTime ~= true then
            zg.timeMgr:AddUpdateFunction(self.updateTime)
            self.isRegisterUpdateTime = true
            self:FirstUpdateTimeUI()
        end
    else
        self:RemoveUpdateTime()
        self:FinishUpdateTimeUI()
    end
end

--- @return void
function RegenTime:RemoveUpdateTime()
    if self.isRegisterUpdateTime == true then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.isRegisterUpdateTime = false
    end
end

--- @return void
function RegenTime:Hide()
    self:RemoveUpdateTime()
    self:_RemoveListener()
end