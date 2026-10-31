---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.DungeonShopItemConfig"

--- @class DungeonShopItemView : MotionIconView
DungeonShopItemView = Class(DungeonShopItemView, MotionIconView)

--- @return void
function DungeonShopItemView:Ctor()
    --- @type IconView
    self.iconView = nil
    --- @type ButtonBuyView
    self.buttonBuyView = nil
    --- @type function
    self.onFinish = nil
    --- @type ItemIconData
    self.itemIconData = nil
    MotionIconView.Ctor(self)
end

--- @return void
--- @param transform UnityEngine_Transform
function DungeonShopItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type DungeonShopItemConfig
    self.config = UIBaseConfig(transform)
    --- @type ButtonBuyView
    self.buttonBuyView = ButtonBuyView(self.config.button)
end

--- @return void
function DungeonShopItemView:SetPrefabName()
    self.prefabName = 'dungeon_shop_item'
    self.uiPoolType = UIPoolType.DungeonShopItemView
end

--- @return void
--- @param iconData MarketItemInBound
function DungeonShopItemView:SetIconData(iconData)
    self.iconData = iconData
    self.itemIconData = self.iconData.reward:GetIconData()
    self:UpdateView()
    self:SetRelease(iconData:CanBuy())
end

--- @return void
--- @param isRelease boolean
function DungeonShopItemView:SetRelease(isRelease)
    self.buttonBuyView:EnableButton(isRelease)
    self.iconView:ActiveMaskSelect(not isRelease)
end

--- @return void
---@param func function
function DungeonShopItemView:AddListener(func)
    assert(func)
    self.buttonBuyView:AddListener(function()
        BuyUtils.InitListener(function()
            ---@type RewardInBound
            local reward = self.iconData.reward
            local cost = self.iconData.cost
            InventoryUtils.Sub(ResourceType.Money, cost.moneyType, cost.value)
            SmartPoolUtils.ShowReward1Item(self.itemIconData)
            reward:AddToInventory()

            if self.onFinish ~= nil then
                self.onFinish(self.iconData)
            end
        end)
        func()
    end)
end

--- @return void
function DungeonShopItemView:ReturnPool()
    MotionIconView.ReturnPool(self)

    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
end


--- @return void
function DungeonShopItemView:UpdateView()
    self:_CreateIconView()
    self:_CreateButtonView()
    self:_SetTextReward()
end

--- @return void
function DungeonShopItemView:_CreateIconView()
    self.iconView = SmartPoolUtils.GetIconViewByIconData(self.itemIconData, self.config.icon)
end

--- @return void
function DungeonShopItemView:_CreateButtonView()
    self.buttonBuyView:SetIconData(self.iconData.cost)
end

--- @return void
function DungeonShopItemView:_SetTextReward()
    self.config.textItemType.text = LanguageUtils.GetStringResourceType(self.itemIconData.type, self.itemIconData.itemId)
    self.config.textItemName.text = LanguageUtils.GetStringResourceName(self.itemIconData.type, self.itemIconData.itemId)

end

return DungeonShopItemView
