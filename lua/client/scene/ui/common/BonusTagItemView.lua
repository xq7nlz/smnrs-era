--- @class BonusTagItemView : IconView
BonusTagItemView = Class(BonusTagItemView, IconView)

--- @return void
function BonusTagItemView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function BonusTagItemView:SetPrefabName()
    self.prefabName = 'bonus_tag_item'
    self.uiPoolType = UIPoolType.BonusTagItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function BonusTagItemView:SetConfig(transform)
    assert(transform)
    ---@type BonusTagItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param reward RewardInBound
function BonusTagItemView:SetData(reward)
    self.config.iconReward.sprite = ResourceLoadUtils.LoadMoneyIcon(reward.id)
    self.config.amountReward.text = reward.number
end

--- @return void
--- @param vector3 UnityEngine_Vector3
function BonusTagItemView:SetLocalLocationOffset(offset)
    self.config.transform.localPosition = self.config.transform.localPosition + offset
end

function BonusTagItemView:ShowInfo()

end

--- @return void
function BonusTagItemView:ReturnPool()
    IconView.ReturnPool(self)
end

return BonusTagItemView