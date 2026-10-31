--- @class ItemShowWithNameAndType
ItemShowWithNameAndType = Class(ItemShowWithNameAndType)

--- @param transform UnityEngine_Transform
function ItemShowWithNameAndType:Ctor(transform)
    --- @type ItemShowWithNameAndTypeConfig
    self.config = UIBaseConfig(transform)
    --- @type RootIconView
    self.rootIconView = nil
end

--- @param rewardInBound RewardInBound
function ItemShowWithNameAndType:SetReward(rewardInBound, desc)
    self:GetItemIconView()
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    self.rootIconView.iconView:_SetQuantity(nil)
    self.rootIconView:RegisterShowInfo()
    self.config.itemDesc.text = desc
    self.config.gameObject:SetActive(true)
end

function ItemShowWithNameAndType:GetItemIconView()
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
    end
end

function ItemShowWithNameAndType:OnHide()
    self.config.gameObject:SetActive(false)
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end