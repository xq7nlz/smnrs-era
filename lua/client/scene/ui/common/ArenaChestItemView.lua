--- @class ArenaChestItemView : IconView
ArenaChestItemView = Class(ArenaChestItemView, IconView)

--- @return void
function ArenaChestItemView:Ctor()
    --- @type AreraChestItemViewConfig
    self.config = nil
    --- @type RewardInBound
    self.reward = nil
    --- @type MoneyIconView
    self.iconView = nil
    --- @type SmallInputNumberView
    self.input = nil
    IconView.Ctor(self)
end

--- @return void
function ArenaChestItemView:SetPrefabName()
    self.prefabName = 'arena_chest_item_view'
    self.uiPoolType = UIPoolType.ArenaChestItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ArenaChestItemView:SetConfig(transform)
    assert(transform)
    ---@type ArenaBattleItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function ArenaChestItemView:InitLocalization()
end

--- @param reward RewardInBound
function ArenaChestItemView:SetData(reward,max)
    self.reward= reward
    self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.moneyAnchor)
    self.iconView:SetIconData(ItemIconData.CreateInstance(self.reward.type, self.reward.itemId,0))
    if self.input == nil then
        self.input = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SmallInputNumberView, self.config.inputNumberViewAnchor)
    end
    self.input:SetData(0,0,max,1)
end

function ArenaChestItemView:SetInputData(max)
    self.input.minValue = 0 ;
    self.input.maxValue = self.input.value + max;
end


--- @return void
function ArenaChestItemView:OnClickInfo()

end

--- @return void
function ArenaChestItemView:ReturnPool()
    IconView.ReturnPool(self)
    self.input.minValue = 0
    self.input.maxValue = 0
    self.input.value = 0
end

return ArenaChestItemView