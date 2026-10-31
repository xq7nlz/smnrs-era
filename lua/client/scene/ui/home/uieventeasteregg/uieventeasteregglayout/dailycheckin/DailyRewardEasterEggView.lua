require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.DailyRewardXmasView"

--- @class DailyRewardEasterEggView : DailyRewardXmasView
DailyRewardEasterEggView = Class(DailyRewardEasterEggView, DailyRewardXmasView)

--- @return void
function DailyRewardEasterEggView:Ctor(onClickClaim, isNewLogin)
    DailyRewardXmasView.Ctor(self, onClickClaim, isNewLogin)
end

--- @return void
function DailyRewardEasterEggView:SetPrefabName()
    self.prefabName = 'daily_reward_easter_egg'
    self.uiPoolType = UIPoolType.DailyRewardEasterEggView
end

function DailyRewardEasterEggView:SetDay7()
    self.light = self.config.light2
    self.config.verticalReward.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.config.verticalReward.transform.localPosition = U_Vector3(0, 30, 0)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 331, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1.2, 1.2, 1)
    self.config.dailyCheckinTag2.gameObject:SetActive(true)
    self.config.dailyCheckinTag.gameObject:SetActive(false)

    self.config.textDailyCheckinDay.color = U_Color(1, 0.96, 0.73, 1)
end

function DailyRewardEasterEggView:SetNormalDay()
    self.light = self.config.light
    self.config.verticalReward.transform.localScale = U_Vector3(1, 1, 1)
    self.config.verticalReward.transform.localPosition = U_Vector3(0, -33, 0)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 128.7, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1, 1, 1)
    self.config.dailyCheckinTag2.gameObject:SetActive(false)
    self.config.dailyCheckinTag.gameObject:SetActive(true)

    self.config.textDailyCheckinDay.color = U_Color(0.56, 0.41, 0.24, 1)
end

return DailyRewardEasterEggView