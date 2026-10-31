--- @class DailyRewardPageView
DailyRewardPageView = Class(DailyRewardPageView)

function DailyRewardPageView:Ctor(anchor, onClickClaim)
    ---@type DailyRewardPageConfig
    self.config = nil
    self.anchor = anchor
    self:InitConfig(onClickClaim)
end

function DailyRewardPageView:FillData(dicLoginDataConfig, page)
    self.dicLoginDataConfig = dicLoginDataConfig
    self.page = page
    --- @param v DailyRewardHalloweenView
    for k, v in pairs(self.tileDayDict:GetItems()) do
        local realKey = k + 7 * (page - 1)
        local loginDataConfig = self.dicLoginDataConfig:Get(realKey)
        v:FillLoginData(loginDataConfig, realKey)
    end
end

function DailyRewardPageView:InitConfig(onClickClaim)
    self.config = UIBaseConfig(self.anchor)
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = DailyRewardHalloweenView(onClickClaim)
        dailyRewardItemView:SetParent(self.config.tile6Days)
        dailyRewardItemView:SetNormalDay()
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = DailyRewardHalloweenView(onClickClaim)
    tile7:SetParent(self.config.tile7)
    tile7:SetDay7()
    self.tileDayDict:Add(7, tile7)
end

function DailyRewardPageView:UpdateView(currentDay, lastClaimDay, isClaim, isFreeClaim)
    ---@param v DailyRewardHalloweenView
    for day, v in pairs(self.tileDayDict:GetItems()) do
        if self.page == nil then
            return
        end
        local dayFinal = day + 7 * (self.page - 1)
        if dayFinal <= lastClaimDay then
            v:SetClaim(true)
            v:SetUnLock()
            v:SetEnableFreeButton()
        elseif dayFinal == lastClaimDay + 1 then
            if isClaim == false and isFreeClaim == false then
                v:SetEnableFreeButton(true)
                v:SetUnLock()
                v:SetClaim(false)
            elseif isClaim == false and isFreeClaim == true then
                v:SetEnableFreeButton(false)
                v:SetUnLock()
                v:SetClaim(false)
            else
                v:SetEnableFreeButton()
                v:SetLock()
                v:SetClaim()
            end
        elseif dayFinal <= currentDay and dayFinal >= lastClaimDay + 2 then
            v:SetClaim()
            v:SetUnLock()
            v:SetEnableFreeButton()
        else
            v:SetClaim()
            v:SetLock()
            v:SetEnableFreeButton()
        end
    end
end

function DailyRewardPageView:GetPageCount()
    return self.page
end

function DailyRewardPageView:GetDayView(claimDay)
    local index = claimDay % 7
    if index == 0 then
        index = claimDay / self.page
    end
    if self.tileDayDict:IsContainKey(index) then
        return self.tileDayDict:Get(index)
    end
    return nil
end

function DailyRewardPageView:SetPosition(position)
    self.config.transform.localPosition = position
end

function DailyRewardPageView:Move(endPos, time, callback)
    self.config.transform:DOLocalMove(endPos, time):OnComplete(function()
        if callback ~= nil then
            callback()
        end
    end)
end

function DailyRewardPageView:SetEnable(isEnable)
    self.config.gameObject:SetActive(isEnable)
end

function DailyRewardPageView:ReturnPools()
    for _, v in pairs(self.tileDayDict:GetItems()) do
        v:TurnOffColor2()
        v:ReturnPoolItem()
    end
end