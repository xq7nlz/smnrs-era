require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.DailyRewardXmasView"

--- @class DailyRewardMergeServerView : DailyRewardXmasView
DailyRewardMergeServerView = Class(DailyRewardMergeServerView, DailyRewardXmasView)

--- @return void
function DailyRewardMergeServerView:Ctor(onClickClaim, isNewLogin)
    DailyRewardXmasView.Ctor(self, onClickClaim, isNewLogin)
end

--- @return void
function DailyRewardMergeServerView:SetPrefabName()
    self.prefabName = 'daily_reward_merge_server'
    self.uiPoolType = UIPoolType.DailyRewardMergeServerView
end

function DailyRewardMergeServerView:SetDay7()
    self.light = self.config.light2
    self.config.verticalReward.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.config.verticalReward.transform.localPosition = U_Vector3(0, 30, 0)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 264.7, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1.2, 1.2, 1)
    self.config.dailyCheckinTag2.gameObject:SetActive(true)
    self.config.dailyCheckinTag.gameObject:SetActive(false)
end

function DailyRewardMergeServerView:SetNormalDay()
    self.light = self.config.light
    self.config.verticalReward.transform.localScale = U_Vector3(1, 1, 1)
    self.config.verticalReward.transform.localPosition = U_Vector3(0, -33, 0)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 128.7, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1, 1, 1)
    self.config.dailyCheckinTag2.gameObject:SetActive(false)
    self.config.dailyCheckinTag.gameObject:SetActive(true)
end

return DailyRewardMergeServerView