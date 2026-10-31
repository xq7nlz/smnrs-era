--- @class MoneyIconView : IconView
MoneyIconView = Class(MoneyIconView, IconView)

--- @return void
function MoneyIconView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function MoneyIconView:SetPrefabName()
    self.prefabName = 'money_icon_info'
    self.uiPoolType = UIPoolType.MoneyIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function MoneyIconView:SetConfig(transform)
    assert(transform)
    --- @type MoneyIconConfig
    ---@type MoneyIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
function MoneyIconView:SetIconData(iconData)
    assert(iconData)
    --- @type ItemIconData
    self.iconData = ItemIconData.Clone(iconData)
    self:UpdateView()
end

--- @return void
---@param func function
function MoneyIconView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

--- @return void
function MoneyIconView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function MoneyIconView:EnableButton(enabled)
    self.config.frame.raycastTarget = enabled
    UIUtils.SetInteractableButton(self.config.button, enabled)
end

--- @return void
function MoneyIconView:UpdateView()
    self:_SetIcon(self.iconData.itemId)
    self:_SetQuantity(self.iconData.quantity)
    self:_SetFrameRarity(ResourceMgr.GetCurrencyRarityConfig():GetRarity(self.iconData.itemId))
end

--- @return void
function MoneyIconView:ReturnPool()
    IconView.ReturnPool(self)
end

---@return void
---@param id number
function MoneyIconView:_SetIcon(id)
    self.config.item.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCurrencies, id)
    --ClientConfigUtils.SetFillSizeImage(self.config.item, 130, 130)
end

---@return void
---@param id number
function MoneyIconView:_SetFrameRarity(_id)
    local id = _id
    if id == nil then
        id = 1
    end
    self.config.frame.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.frameItem, "currency_" .. id)
end

--- @return void
--- @param quantity number
function MoneyIconView:_SetQuantity(quantity)
    if quantity == nil then
        self.config.number.text = ""
    else
        self.config.number.text = ClientConfigUtils.FormatNumber(quantity)
        UIUtils.SetTextTestValue(self.config, quantity)
    end
end

--- @return void
function MoneyIconView:SetQuantityAndInventory()
    local currentMoney = InventoryUtils.GetMoney(self.iconData.itemId)
    self.config.number.text = ClientConfigUtils.FormatTextAPB(self.iconData.quantity, currentMoney)
end

--- @return void
function MoneyIconView:ShowInfo()
    if self.iconData ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = ResourceType.Money, ["id"] = self.iconData.itemId, ["rate"] = self.rate}})
    end
end

return MoneyIconView

