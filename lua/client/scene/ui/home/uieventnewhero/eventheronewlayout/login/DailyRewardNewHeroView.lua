require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.DailyRewardXmasView"

--- @class DailyRewardNewHeroView : DailyRewardXmasView
DailyRewardNewHeroView = Class(DailyRewardNewHeroView, DailyRewardXmasView)

--- @return void
function DailyRewardNewHeroView:Ctor(onClickClaim, isNewLogin)
    DailyRewardXmasView.Ctor(self, onClickClaim, isNewLogin)
end

--- @return void
function DailyRewardNewHeroView:SetPrefabName()
    self.prefabName = 'daily_reward_new_hero_1'
    self.uiPoolType = UIPoolType.DailyRewardNewHeroView
end

function DailyRewardNewHeroView:SetDay7()
    self.light = self.config.light2
    self.config.dailyCheckinTag2.gameObject:SetActive(true)
    self.config.dailyCheckinTag.gameObject:SetActive(false)
    if self.config.textDailyCheckinDay7 ~= nil then
        self.config.textDailyCheckinDay.gameObject:SetActive(false)
        self.config.textDailyCheckinDay7.gameObject:SetActive(true)
    end
end

function DailyRewardNewHeroView:SetNormalDay()
    self.light = self.config.light
    self.config.dailyCheckinTag2.gameObject:SetActive(false)
    self.config.dailyCheckinTag.gameObject:SetActive(true)
    if self.config.textDailyCheckinDay7 ~= nil then
        self.config.textDailyCheckinDay.gameObject:SetActive(true)
        self.config.textDailyCheckinDay7.gameObject:SetActive(false)
    end
end

return DailyRewardNewHeroView