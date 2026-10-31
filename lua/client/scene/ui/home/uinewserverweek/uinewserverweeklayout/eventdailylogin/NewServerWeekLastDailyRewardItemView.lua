--- @class NewServerWeekLastDailyRewardItemView : NewServerWeekDailyRewardItemView
NewServerWeekLastDailyRewardItemView = Class(NewServerWeekLastDailyRewardItemView, NewServerWeekDailyRewardItemView)

--- @return void
function NewServerWeekLastDailyRewardItemView:Ctor()
    NewServerWeekDailyRewardItemView.Ctor(self)
end

--- @return void
function NewServerWeekLastDailyRewardItemView:SetPrefabName()
    self.prefabName = 'new_server_daily_reward_day_7_item'
    self.uiPoolType = UIPoolType.NewServerWeekLastDailyRewardItemView
end

return NewServerWeekLastDailyRewardItemView