require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
--- @class DailyRewardMergeServerPageView : DailyRewardPageView
DailyRewardMergeServerPageView = Class(DailyRewardMergeServerPageView, DailyRewardPageView)

--- @return void
function DailyRewardMergeServerPageView:Ctor(anchor, onClickClaim, isNewLogin)
    self.isNewLogin = isNewLogin
    DailyRewardPageView.Ctor(self, anchor, onClickClaim)
end

function DailyRewardMergeServerPageView:InitConfig(onClickClaim)
    self.config = UIBaseConfig(self.anchor)
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = DailyRewardMergeServerView(onClickClaim, self.isNewLogin)
        dailyRewardItemView:SetParent(self.config.tile6Days)
        dailyRewardItemView:SetNormalDay()
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = DailyRewardMergeServerView(onClickClaim, self.isNewLogin)
    tile7:SetParent(self.config.tile7)
    tile7:SetDay7()
    self.tileDayDict:Add(7, tile7)
end

function DailyRewardMergeServerPageView:UpdateView(currentDay, lastClaimDay, isClaim, isFreeClaim)
    if self.isNewLogin then
        DailyRewardPageView.UpdateView(self, currentDay, lastClaimDay, isClaim,isFreeClaim)
    else
        ---@param v DailyRewardMergeServerView
        for day, v in pairs(self.tileDayDict:GetItems()) do
            if day <= lastClaimDay then
                v:SetClaim(true)
            elseif day == lastClaimDay + 1 and isFreeClaim == false then
                v:SetClaim(false)
            else
                v:SetClaim()
            end
        end

    end
end