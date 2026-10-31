require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.dailyCheckin.DailyRewardLunarNewYearView"
--- @class DailyRewardLunarNewYearPageView : DailyRewardPageView
DailyRewardLunarNewYearPageView = Class(DailyRewardLunarNewYearPageView, DailyRewardPageView)

--- @return void
function DailyRewardLunarNewYearPageView:Ctor(anchor, onClickClaim, isNewLogin)
    self.isNewLogin = isNewLogin
    DailyRewardPageView.Ctor(self, anchor, onClickClaim)
end

function DailyRewardLunarNewYearPageView:InitConfig(onClickClaim)
    self.config = UIBaseConfig(self.anchor)
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = DailyRewardLunarNewYearView(onClickClaim, self.isNewLogin)
        dailyRewardItemView:SetParent(self.config.tile6Days)
        dailyRewardItemView:SetNormalDay()
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = DailyRewardLunarNewYearView(onClickClaim, self.isNewLogin)
    tile7:SetParent(self.config.tile7)
    tile7:SetDay7()
    self.tileDayDict:Add(7, tile7)
end

function DailyRewardLunarNewYearPageView:UpdateView(currentDay, lastClaimDay, isClaim, isFreeClaim)
    ---@param v DailyRewardHalloweenView
    for day, v in pairs(self.tileDayDict:GetItems()) do
        if self.page == nil then
            XDebug.Log("page nil")
            return
        end
        local dayFinal = day + 7 * (self.page - 1)
        if dayFinal <= lastClaimDay then
            v:SetClaim(true)
        elseif dayFinal == lastClaimDay + 1 then
            if isClaim == false and isFreeClaim == false then
                v:SetClaim(false)
            elseif isClaim == false and isFreeClaim == true then
                v:SetClaim(false)
            else
                v:SetClaim()
            end
        elseif dayFinal <= currentDay and dayFinal >= lastClaimDay + 2 then
            v:SetClaim()
        else
            v:SetClaim()
        end
    end
end
