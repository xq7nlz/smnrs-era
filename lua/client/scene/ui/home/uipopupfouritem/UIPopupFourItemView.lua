--- @class UIPopupFourItemView : UIBaseView
UIPopupFourItemView = Class(UIPopupFourItemView, UIBaseView)

--- @return void
--- @param model UIPopupRewardModel
function UIPopupFourItemView:Ctor(model, ctrl)
    --- @type UIPopupFourItemConfig
    self.config = nil
    ---@type List
    self.itemList = List()
    ---@type function
    self.callbackSelect = nil
    --- @type UIPopupRewardModel
    self.model = self.model
    UIBaseView.Ctor(self, model, ctrl)
end

--- @return void
function UIPopupFourItemView:OnReadyCreate()
    ---@type UIPopupFourItemConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButton()
end

--- @return void
function UIPopupFourItemView:InitButton()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIPopupFourItemView:InitLocalization()
    self.config.textTapToClose.text = LanguageUtils.LocalizeCommon("tap_to_close")
end

--- @return void
function UIPopupFourItemView:SetTextTitle(text)
    self.config.textTitle.text = text
end

--- @return void
--- @param itemDict Dictionary
--- @param isTarget boolean
function UIPopupFourItemView:SetItemAnchor(itemDict, isTarget, idExchange, exchangeId)
    ---@param v RewardInBound
    for _, v in pairs(itemDict:GetItems()) do
        ---@type RootIconView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
        ---@type ItemIconData
        local itemIconData = v:GetIconData()
        if isTarget then
            itemIconData.quantity = nil
            item:SetIconData(itemIconData)
            item:SetActiveColor(true)
            item:AddListener(function()
                if self.callbackSelect then
                    zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
                    self:OnClickBackOrClose()
                    self.callbackSelect(v)
                end
            end)
            if idExchange and idExchange == v.id then
                item:SetActiveColor(false)
                item:AddListener(function()
                    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("cant_not_exchange_same_item"))
                end)
            end
        else
            local quantity = InventoryUtils.GetMoney(v.id)
            itemIconData.quantity = quantity
            item:SetIconData(itemIconData)
            item:SetActiveColor(true)
            if quantity <= 0 then
                item:SetActiveColor(false)
                item:AddListener(function()
                    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("you_have_no_this_resource"))
                end)
            else
                item:AddListener(function()
                    if self.callbackSelect then
                        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
                        self:OnClickBackOrClose()
                        self.callbackSelect(v)
                    end
                end)
                if exchangeId and exchangeId == v.id then
                    item:SetActiveColor(false)
                    item:AddListener(function()
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("cant_not_exchange_same_item"))
                    end)
                end
            end
        end
        self.itemList:Add(item)
    end
end

--- @return void
function UIPopupFourItemView:ReturnPoolListItem()
    ---@param v RootIconView
    for _, v in pairs(self.itemList:GetItems()) do
        v:ReturnPool()
    end
    self.itemList:Clear()
end

--- @return void
---@param data {titleText, itemDict|Dictionary, callbackSelect|function, isTarget, idExchange, exchangeId}
function UIPopupFourItemView:OnReadyShow(data)
    self.callbackSelect = data.callbackSelect
    self:InitLocalization()
    self:SetTextTitle(data.titleText)
    self:SetItemAnchor(data.itemDict, data.isTarget, data.idExchange, data.exchangeId)
end

--- @return void
function UIPopupFourItemView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPoolListItem()
    if self.callbackSelect then
        self.callbackSelect()
    end
end

--- @return void
function UIPopupFourItemView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
end