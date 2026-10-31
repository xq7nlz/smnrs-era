require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopMonthlyCardLayout.UISubscriptionPackView"
--- @class UITrialMonthlyCardView : UIBaseView
UITrialMonthlyCardView = Class(UITrialMonthlyCardView, UIBaseView)

--- @return void
--- @param model UITrialMonthlyCardModel
function UITrialMonthlyCardView:Ctor(model)
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type UITrialMonthlyCardConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type List
    self.listPack = nil
    UIBaseView.Ctor(self, model)
    --- @type UITrialMonthlyCardModel
    self.model = model
end

--- @return void
function UITrialMonthlyCardView:OnReadyCreate()
    ---@type UITrialMonthlyCardConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitMonthlyCard()
end

function UITrialMonthlyCardView:InitLocalization()
    self.config.textTapToClose.gameObject:SetActive(false)
    if self.listPack == nil then
        return
    end
    for i = 1, self.listPack:Count() do
        --- @type UISubscriptionPackView
        local pack = self.listPack:Get(i)
        pack:InitLocalization()
    end
end

function UITrialMonthlyCardView:_InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UITrialMonthlyCardView:_InitMonthlyCard()
    self.listPack = List()
    local pack2 = UISubscriptionPackView(self.config.packAnchor:GetChild(0), 2)
    local pack3 = UISubscriptionPackView(self.config.packAnchor:GetChild(1), 3)
    self.listPack:Add(pack2)
    self.listPack:Add(pack3)
end

function UITrialMonthlyCardView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
    for i = 1, self.listPack:Count() do
        --- @type UISubscriptionPackView
        local pack = self.listPack:Get(i)
        pack:ShowPack()
    end
end

function UITrialMonthlyCardView:OnClickBackOrClose()
    IapDataInBound.SetAutoShowedTrialMonthlyByCampaignStage()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
    --PopupMgr.HidePopup(self.model.uiName)
    --zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    --if self.callbackClose ~= nil then
    --    self.callbackClose()
    --end
end

