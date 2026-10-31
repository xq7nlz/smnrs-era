--- @class StageIdleRewardItemView : IconView
StageIdleRewardItemView = Class(StageIdleRewardItemView, IconView)

--- @return void
function StageIdleRewardItemView:Ctor()
    IconView.Ctor(self)
end
--- @return void
function StageIdleRewardItemView:SetPrefabName()
    self.prefabName = 'stage_idle_reward'
    self.uiPoolType = UIPoolType.StageIdleRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function StageIdleRewardItemView:SetConfig(transform)
    ---@type StageIdleRewardItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param idle LandIdleRewardItemConfig
--- @param next LandIdleRewardItemConfig
function StageIdleRewardItemView:SetData(idle, next)
    ---@type RewardInBound
    local rewardInBound = nil
    if next ~= nil then
        rewardInBound = next.rewardInBound
    else
        rewardInBound = idle.rewardInBound
    end
    if rewardInBound.type == ResourceType.HeroFragment then
        self.config.iconCoin.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentCurrencies, rewardInBound.id % 10)
    else
        self.config.iconCoin.sprite = ResourceLoadUtils.LoadMoneyIcon(rewardInBound.id)
    end
    self.config.iconCoin:SetNativeSize()
    if idle ~= nil then
        self.config.textCoinValue.text = string.format("%s/%ss", idle.rewardInBound.number, idle.intervalTime)
    else
        self.config.textCoinValue.text = string.format("%s/%ss", 0, next.intervalTime)
    end
    if next ~= nil then
        self.config.textCoinValueNext.text = string.format("%s/%ss", next.rewardInBound.number, next.intervalTime)
    else
        self.config.textCoinValueNext.text = string.format("%s/%ss", idle.rewardInBound.number, idle.intervalTime)
    end
end

return StageIdleRewardItemView