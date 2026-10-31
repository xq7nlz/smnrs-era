require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
--- @class NewServerWeekDailyRewardPageView : DailyRewardPageView
NewServerWeekDailyRewardPageView = Class(NewServerWeekDailyRewardPageView,DailyRewardPageView)

function NewServerWeekDailyRewardPageView:InitConfig(onClickClaim)
    self.config = UIBaseConfig(self.anchor)
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = NewServerWeekDailyRewardItemView(onClickClaim)
        dailyRewardItemView:SetParent(self.config.tile6Days)
        dailyRewardItemView:SetNormalDay()
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = NewServerWeekDailyRewardItemView(onClickClaim)
    tile7:SetParent(self.config.tile7)
    tile7:SetDay7()
    self.tileDayDict:Add(7, tile7)
end