--- @class MoneyBarView : IconView
MoneyBarView = Class(MoneyBarView, IconView)

--- @return void
function MoneyBarView:Ctor()
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
function MoneyBarView:SetPrefabName()
    self.prefabName = 'money_bar_info'
    self.uiPoolType = UIPoolType.MoneyBarView
end

--- @return void
--- @param transform UnityEngine_Transform
function MoneyBarView:SetConfig(transform)
    if transform == nil then
        XDebug.Error("MoneyBarView => transform is nil")
    end
    --- @type MoneyBarConfig
    ---@type MoneyBarConfig
    self.config = UIBaseConfig(transform)
    self:SetActive(false)
end

--- @return void
--- @param moneyType MoneyType
function MoneyBarView:SetIconData(moneyType, isListen, needHighLight, isConsume)
    assert(moneyType)
    self.isListen = isListen ~= nil and isListen or true
    self.needHighLight = needHighLight ~= nil and needHighLight or false
    self.isConsume = isConsume ~= nil and isConsume or true
    self.moneyType = moneyType
    self:UpdateView()
    if self.isListen == true then
        self:_InitListener()
    end
    if ResourceMgr.GetCurrencyCollectionConfig():IsContainMoneyType(moneyType) then
        self.config.buttonInfo.interactable = true
        self.config.buttonInfo.onClick:RemoveAllListeners()
        self.config.buttonInfo.onClick:AddListener(function ()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:ShowInfo()
        end)
    else
        self.config.buttonInfo.interactable = false
    end
end

--- @return void
function MoneyBarView:_InitListener()
    if self.listener == nil then
        self.listener = RxMgr.changeResource:Subscribe(RxMgr.CreateFunction(self, self._OnChangeResource))
    end
end

--- @return void
function MoneyBarView:_RemoveListener()
    if self.listener ~= nil then
        self.listener:Unsubscribe()
        self.listener = nil
    end
end

--- @return void
--- @param data table
---{['resourceType'] = self.type, ['resourceId'] = resourceId, ['quantity'] = quantity, ['result'] = self._resourceDict:Get(resourceId)})
function MoneyBarView:_OnChangeResource(data)
    local result = data.result
    local type = data.resourceType
    --- @type MoneyType
    local resourceId = data.resourceId
    if type == ResourceType.Money and resourceId == self.moneyType then
        if self.cacheBuyValue == nil then
            self:SetMoneyText(result)
        else
            self:SetBuyText(self.cacheBuyValue)
        end
    end
end

--- @return void
---@param func function
function MoneyBarView:AddListener(func)
    self:SetActive(true)
    self.config.buttonMoney.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func()
        end
    end)
end

--- @return void
function MoneyBarView:RemoveAllListeners()
    self:SetActive(false)
    self.config.buttonMoney.onClick:RemoveAllListeners()
end

--- @return void
function MoneyBarView:UpdateView()
    self:SetMoneyText(InventoryUtils.GetMoney(self.moneyType))
    self:SetMoneyIcon()

    self:Reverse(false)
end

--- @return void
function MoneyBarView:SetMoneyIcon()
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(self.moneyType)
    self.config.iconMoney:SetNativeSize()
end

--- @return void
--- @param value number
function MoneyBarView:SetMoneyText(value)
    if self.config.textMoney ~= nil then
        self.config.textMoney.text = ClientConfigUtils.FormatNumber(value)
    end
    UIUtils.SetTextTestValue(self.config, value)
end

--- @return void
--- @param value string
function MoneyBarView:SetMoneyText2(value)
    if self.config.textMoney ~= nil then
        self.config.textMoney.text = value
    end
    UIUtils.SetTextTestValue(self.config, value)
end

--- @return void
--- @param isActive boolean
function MoneyBarView:SetActive(isActive)
    if self.config.buttonMoney ~= nil then
        self.config.buttonMoney.gameObject:SetActive(isActive)
    end
end

--- @return void
--- @param isReverse boolean
function MoneyBarView:Reverse(isReverse)
    if isReverse ~= nil and isReverse ~= self.isReverse then
        self.isReverse = isReverse
        local scale = isReverse and U_Vector3(-1, 1, 1) or U_Vector3.one
        self.config.bgMoney.localScale = scale
        self.config.iconMoney.transform.localScale = scale
    end
end

--- @return void
function MoneyBarView:ReturnPool()
    IconView.ReturnPool(self)
    self:_RemoveListener()
    self.cacheBuyValue = nil
end

--- @return void
--- @param value number -- money need to buy item
function MoneyBarView:SetBuyText(value)
    self.cacheBuyValue = value
    local price, currentMoney = self:GetNumberFormat(value)
    self.config.textMoney.text = self.needHighLight and ClientConfigUtils.FormatTextAPB(price, currentMoney) or
            string.format("%s/%s", currentMoney, price)
end

--- @return void
--- @param value number -- money need to buy item
function MoneyBarView:SetText1(value)
    self.cacheBuyValue = value
    local price, currentMoney = self:GetNumberFormat(value)
    self.config.textMoney.text = self.needHighLight and ClientConfigUtils.FormatTextAPB(price, currentMoney) or
            string.format("%s/%s", ClientConfigUtils.FormatNumber(price), ClientConfigUtils.FormatNumber(currentMoney))
end

--- @return UnityEngine_UI_Text
function MoneyBarView:GetText()
    return self.config.textMoney
end

function MoneyBarView:GetNumberFormat(value)
    local currentMoney = InventoryUtils.GetMoney(self.moneyType)
    if self.isConsume == false then
        local temp = value
        value = currentMoney
        currentMoney = temp
    end
    return value, currentMoney
end

--- @return void
function MoneyBarView:ShowInfo()
    if self.moneyType ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = ResourceType.Money, ["id"] = self.moneyType}})
    end
end

function MoneyBarView:RegisterShowInfo()
    --- do nothing
end

return MoneyBarView

