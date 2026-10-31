--- @class UIUpgradeMarketView : UIBaseView
UIUpgradeMarketView = Class(UIUpgradeMarketView, UIBaseView)

function UIUpgradeMarketView:Ctor(model)
    ---@type PopupUpgradeMarketConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type function
    self.yesCallback = nil
    UIBaseView.Ctor(self, model)
    --- @type UIUpgradeMarketModel
    self.model = model
end

function UIUpgradeMarketView:OnReadyCreate()
    ---@type UIScrollLoopRewardConfig
    self.config = UIBaseConfig(self.uiTransform)

    --- @param obj IconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local data = self.model.resourceList:Get(index + 1)
        --XDebug.Log(LogUtils.ToDetail(data))
        obj:SetIconData(data)
        obj:AddListener(function()
            PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = obj.iconData.type, ["id"] = obj.iconData.itemId , ["rate"] = obj.rate}})
        end)
    end

    self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.RootIconView, onCreateItem)
    self.uiScroll:Resize(self.model.resourceList:Count())

    self:_InitButtonListener()
end

--- @return void
function UIUpgradeMarketView:InitLocalization()
    self.config.titleText.text = LanguageUtils.LocalizeCommon("notice")
    self.config.textNo.text = LanguageUtils.LocalizeCommon("cancel")
    self.config.textYes.text = LanguageUtils.LocalizeCommon("confirm")
    self.config.marketUpgradeDescribe.text = LanguageUtils.LocalizeCommon("market_upgrade_describe")
end

--- @return void
function UIUpgradeMarketView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgFog.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonNo.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonYes.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.yesCallback ~= nil then
            self.yesCallback()
        end
    end)
end

--- @return void
function UIUpgradeMarketView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if result ~= nil then
        self:_Init(result)
    end
end

--- @return void
function UIUpgradeMarketView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end

--- @return void
function UIUpgradeMarketView:_Init(result)
    self.model.resourceList = result.resourceList
    if result.yesCallback ~= nil then
        self.config.yesNo:SetActive(true)
        self.yesCallback = result.yesCallback
    else
        self.config.yesNo:SetActive(false)
    end

    self.uiScroll:Resize(self.model.resourceList:Count())
    self:_SetButton()
end

--- @return void
function UIUpgradeMarketView:_SetButton()
    --self.config.textButton.text = self.model.textButton
end