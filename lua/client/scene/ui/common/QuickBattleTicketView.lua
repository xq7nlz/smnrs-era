--- @class QuickBattleTicketView : IconView
QuickBattleTicketView = Class(QuickBattleTicketView, IconView)

--- @return void
function QuickBattleTicketView:Ctor()
    IconView.Ctor(self)
    ---@type QuickBattleTicketData
    self.quickBattleTicketData = nil
end

--- @return void
function QuickBattleTicketView:SetPrefabName()
    self.prefabName = 'quick_battle_ticket'
    self.uiPoolType = UIPoolType.QuickBattleTicketView
end

--- @return void
--- @param transform UnityEngine_Transform
function QuickBattleTicketView:SetConfig(transform)
    assert(transform)
    --- @type QuickBattleTicketConfig
    ---@type QuickBattleTicketConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
function QuickBattleTicketView:SetIconData(iconData)
    assert(iconData)
    --- @type ItemIconData
    self.iconData = ItemIconData.Clone(iconData)
    self.quickBattleTicketData = ResourceMgr.GetCampaignQuickBattleTicketConfig():GetTicket(self.iconData.itemId)
    self:UpdateView()
end

--- @return void
---@param func function
function QuickBattleTicketView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function QuickBattleTicketView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function QuickBattleTicketView:EnableButton(enabled)
    self.config.frame.raycastTarget = enabled
    UIUtils.SetInteractableButton(self.config.button, enabled)
end

--- @return void
function QuickBattleTicketView:UpdateView()
    self:_SetIcon(self.iconData.itemId)
    self:_SetQuantity(self.iconData.quantity)
    self:_SetTime()
end

--- @return void
function QuickBattleTicketView:ReturnPool()
    IconView.ReturnPool(self)
    self.quickBattleTicketData = nil
end

---@return void
---@param id number
function QuickBattleTicketView:_SetIcon(id)
    self.config.item.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconQuickBattleTicket, id)
end

--- @return void
--- @param quantity number
function QuickBattleTicketView:_SetQuantity(quantity)
    if quantity == nil then
        self.config.number.text = ""
    else
        self.config.number.text = ClientConfigUtils.FormatNumber(quantity)
        UIUtils.SetTextTestValue(self.config, quantity)
    end
end

--- @return void
function QuickBattleTicketView:_SetTime()
    if self.quickBattleTicketData ~= nil then
        self.config.textTime.text = string.format(LanguageUtils.LocalizeCommon("hour_x"), self.quickBattleTicketData:GetHour())
    end
end

--- @return void
function QuickBattleTicketView:ShowInfo()
    if self.iconData ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = self.iconData.type, ["id"] = self.iconData.itemId, ["rate"] = self.rate}})
    end
end

return QuickBattleTicketView

