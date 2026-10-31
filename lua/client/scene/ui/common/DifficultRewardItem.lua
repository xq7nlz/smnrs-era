--- @class DifficultRewardItem : MotionIconView
DifficultRewardItem = Class(DifficultRewardItem, MotionIconView)

--- @return void
function DifficultRewardItem:Ctor()
    ---@type DifficultRewardItemConfig
    self.config = nil
    MotionIconView.Ctor(self)
end

function DifficultRewardItem:SetPrefabName()
    self.prefabName = 'difficult_reward_item'
    self.uiPoolType = UIPoolType.DifficultRewardItem
end

--- @param transform UnityEngine_Transform
function DifficultRewardItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type DifficultRewardItemConfig
    self.config = UIBaseConfig(transform)
end

---@param rewardList List()
function DifficultRewardItem:SetItemData(rewardList, localize)
    self.config.labelText.text = localize or "N/a"
    ---@param v RewardInBound
    for _, v in pairs(rewardList:GetItems()) do
        self:SetItemReward(v)
    end
end

---@param rewardInBound RewardInBound
function DifficultRewardItem:SetItemReward(rewardInBound)
    if self.rootIconView == nil and rewardInBound ~= nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    end
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    self.rootIconView:RegisterShowInfo()
end

function DifficultRewardItem:ReturnPool()
    MotionIconView.ReturnPool(self)
end

return DifficultRewardItem