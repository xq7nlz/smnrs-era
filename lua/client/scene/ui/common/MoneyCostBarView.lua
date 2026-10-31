--- @class MoneyCostBarView : IconView
MoneyCostBarView = Class(MoneyCostBarView, IconView)

--- @return void
function MoneyCostBarView:Ctor()
    --- @type boolean
    self.needHighLight = false
    ---@type boolean
    self.isListen = true
    --- @type boolean
    self.isReverse = false
    --- @type number
    self.cacheBuyValue = nil
    IconView.Ctor(self)
end

--- @return void
function MoneyCostBarView:SetPrefabName()
    self.prefabName = 'money_bar_info'
    self.uiPoolType = UIPoolType.MoneyCostBarView
end

--- @return void
--- @param transform UnityEngine_Transform
function MoneyCostBarView:SetConfig(transform)
    if transform == nil then
        XDebug.Error("MoneyCostBarView => transform is nil")
    end
    --- @type MoneyBarConfig
    ---@type MoneyBarConfig
    self.config = UIBaseConfig(transform)
    self:SetActive(false)
end

--- @return void
--- @param itemIconData ItemIconData
function MoneyCostBarView:SetIconData(itemIconData)
    self:SetMoneyIcon(itemIconData.itemId)
    self:SetMoneyText(itemIconData.quantity)
end

--- @return void
function MoneyCostBarView:SetMoneyIcon(moneyType)
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyType)
    self.config.iconMoney:SetNativeSize()
end

--- @return void
--- @param value number
function MoneyCostBarView:SetMoneyText(value)
    if self.config.textMoney ~= nil then
        self.config.textMoney.text = ClientConfigUtils.FormatNumber(value)
    end
    UIUtils.SetTextTestValue(self.config, value)
end

--- @return void
--- @param isActive boolean
function MoneyCostBarView:SetActive(isActive)
    if self.config.buttonMoney ~= nil then
        self.config.buttonMoney.gameObject:SetActive(isActive)
    end
end


--- @return void
function MoneyCostBarView:ReturnPool()
    IconView.ReturnPool(self)
end

--- @return void
function MoneyCostBarView:ShowInfo()
    if self.moneyType ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = ResourceType.Money, ["id"] = self.moneyType}})
    end
end

return MoneyCostBarView

