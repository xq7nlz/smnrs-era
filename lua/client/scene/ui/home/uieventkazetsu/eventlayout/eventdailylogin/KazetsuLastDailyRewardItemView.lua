--- @class KazetsuLastDailyRewardItemView : KazetsuDailyRewardItemView
KazetsuLastDailyRewardItemView = Class(KazetsuLastDailyRewardItemView, KazetsuDailyRewardItemView)

--- @return void
function KazetsuLastDailyRewardItemView:Ctor()
    KazetsuDailyRewardItemView.Ctor(self)
end

--- @return void
function KazetsuLastDailyRewardItemView:SetPrefabName()
    self.prefabName = 'kazetsu_daily_reward_day_7_item'
    self.uiPoolType = UIPoolType.KazetsuLastDailyRewardItemView
end

return KazetsuLastDailyRewardItemView