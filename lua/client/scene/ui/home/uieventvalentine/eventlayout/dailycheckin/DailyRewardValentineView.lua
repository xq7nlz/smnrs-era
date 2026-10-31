require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.DailyRewardXmasView"

--- @class DailyRewardValentineView : DailyRewardXmasView
DailyRewardValentineView = Class(DailyRewardValentineView, DailyRewardXmasView)

--- @return void
function DailyRewardValentineView:Ctor(onClickClaim, isNewLogin)
    DailyRewardXmasView.Ctor(self, onClickClaim, isNewLogin)
end

--- @return void
function DailyRewardValentineView:SetPrefabName()
    self.prefabName = 'daily_reward_valentine'
    self.uiPoolType = UIPoolType.DailyRewardValentineView
end

return DailyRewardValentineView