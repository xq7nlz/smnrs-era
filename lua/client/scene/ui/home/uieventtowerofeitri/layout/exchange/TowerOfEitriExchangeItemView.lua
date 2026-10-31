--- @class TowerOfEitriExchangeItemView : RootIconView
TowerOfEitriExchangeItemView = Class(TowerOfEitriExchangeItemView, RootIconView)
function TowerOfEitriExchangeItemView:Ctor()
    RootIconView.Ctor(self)
end

--- @return void
function TowerOfEitriExchangeItemView:SetPrefabName()
    self.prefabName = 'event_tower_of_eitri_exchange_item'
    self.uiPoolType = UIPoolType.UIEventTowerOfEitriExchangeItem
end

--- @return void
--- @param transform UnityEngine_RectTransform
function TowerOfEitriExchangeItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type TowerOfEitriExchangeItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param itemIconData EventTowerOfEitriExchangeItemData
function TowerOfEitriExchangeItemView:SetIconData(itemIconData)
    RootIconView.SetIconData(self,itemIconData.itemData:GetIconData())
    local remain = (itemIconData.limit - itemIconData.buyTime)
    UIUtils.SetActiveColor(self.config.gameObject, remain > 0 )
    self.config.stock.text = LanguageUtils.LocalizeCommon("stock").. ": ".. UIUtils.SetColorString(UIUtils.green_light,tostring(remain))
    self.config.priceText.text = itemIconData.price
end

--- @return void
--- @param func function
function TowerOfEitriExchangeItemView:AddListener(func)
    if self.config.buttonExchange ~= nil then
        self.config.buttonExchange.onClick:RemoveAllListeners()
        self.config.buttonExchange.onClick:AddListener(func)
    end
end

--- @return void
--- @param func function
function TowerOfEitriExchangeItemView:RemoveAllListeners(func)
    if self.iconView ~= nil then
        self.iconView:RemoveAllListeners()
    end
end

--- @return void
function TowerOfEitriExchangeItemView:Show()
    RootIconView.Show(self)
end

--- @return void
function TowerOfEitriExchangeItemView:ReturnPool()
    UIUtils.SetActiveColor(self.config.gameObject,true)
    RootIconView.ReturnPool(self)
end


return TowerOfEitriExchangeItemView
