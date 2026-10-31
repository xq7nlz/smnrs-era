require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.login.DailyRewardNewHeroView"
--- @class DailyRewardNewHeroPageView : DailyRewardPageView
DailyRewardNewHeroPageView = Class(DailyRewardNewHeroPageView, DailyRewardPageView)

--- @return void
function DailyRewardNewHeroPageView:Ctor(anchor, onClickClaim, isNewLogin, prefabName)
    self.prefabName = prefabName
    self.isNewLogin = isNewLogin
    DailyRewardPageView.Ctor(self, anchor, onClickClaim)
end

function DailyRewardNewHeroPageView:InitConfig(onClickClaim)
    self.config = UIBaseConfig(self.anchor)
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = DailyRewardNewHeroView(onClickClaim, self.isNewLogin)
        dailyRewardItemView:OverridePrefab(self.prefabName)
        dailyRewardItemView:SetParent(self.config.tile6Days)
        dailyRewardItemView:SetNormalDay()
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = DailyRewardNewHeroView(onClickClaim, self.isNewLogin)
    tile7:OverridePrefab(self.prefabName)
    tile7:SetParent(self.config.tile7)
    tile7:SetDay7()
    self.tileDayDict:Add(7, tile7)
end

function DailyRewardNewHeroPageView:UpdateView(currentDay, lastClaimDay, isClaim, isFreeClaim)
    if self.isNewLogin then
        DailyRewardPageView.UpdateView(self, currentDay, lastClaimDay, isClaim,isFreeClaim)
    else
        ---@param v DailyRewardValentineView
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