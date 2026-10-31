require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.DailyRewardXmasView"

--- @class DailyRewardEventBirthdayView : DailyRewardXmasView
DailyRewardEventBirthdayView = Class(DailyRewardEventBirthdayView, DailyRewardXmasView)

--- @return void
function DailyRewardEventBirthdayView:Ctor(onClickClaim, isNewLogin)
    DailyRewardXmasView.Ctor(self, onClickClaim, isNewLogin)
end

--- @return void
function DailyRewardEventBirthdayView:SetPrefabName()
    self.prefabName = 'daily_reward_birthday'
    self.uiPoolType = UIPoolType.DailyRewardEventBirthdayView
end

function DailyRewardEventBirthdayView:SetDay7()
    self.light = self.config.light2
    self.config.verticalReward.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.config.verticalReward.transform.localPosition = U_Vector3(0, 30, 0)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 232.3, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1.2, 1.2, 1)
    self.config.dailyCheckinTag2.gameObject:SetActive(true)
    self.config.dailyCheckinTag.gameObject:SetActive(false)

    self.config.textDailyCheckinDay.color = U_Color(1, 0.96, 0.54, 1)
    self.config.tick.transform.localPosition = U_Vector3(0, 28, 0)
end

function DailyRewardEventBirthdayView:SetNormalDay()
    self.light = self.config.light
    self.config.verticalReward.transform.localScale = U_Vector3(1, 1, 1)
    self.config.verticalReward.transform.localPosition = U_Vector3(0, -33, 0)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 137, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1, 1, 1)
    self.config.dailyCheckinTag2.gameObject:SetActive(false)
    self.config.dailyCheckinTag.gameObject:SetActive(true)

    self.config.textDailyCheckinDay.color = U_Color(0.57, 0.41, 0.25, 1)
    self.config.tick.localPosition = U_Vector3(0, -35, 0)
end

return DailyRewardEventBirthdayView