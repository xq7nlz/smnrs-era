--- @class UIPopupNotificationRewardView : UIBaseView
UIPopupNotificationRewardView = Class(UIPopupNotificationRewardView, UIBaseView)

--- @param model UIPopupNotificationRewardModel
function UIPopupNotificationRewardView:Ctor(model)
    --- @type UIPopupNotificationRewardConfig
    self.config = nil
    self.yesCallback = nil
    self.listRewardInBound = nil
    UIBaseView.Ctor(self, model)
    --- @type UIPopupNotificationRewardModel
    self.model = model
end

function UIPopupNotificationRewardView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtons()

    ---@param obj RootIconView
    local onCreateItem = function(obj, index)
        local data = self.model.resourceList:Get(index + 1)
        --XDebug.Log(LogUtils.ToDetail(data))
        obj:AddListener(function()
            PopupMgr.ShowPopup(UIPopupName.UIItemPreview, data)
        end)
        obj:SetIconData(data)
        obj:AddListener(function()
            local rewardInBound = self.listRewardInBound:Get(index + 1)
            PopupMgr.ShowPopup(UIPopupName.UIItemPreview,
                    { ["data1"] = { ["type"] = rewardInBound.type, ["id"] = rewardInBound.id } })
            --XDebug.Log("Click Item: " .. LogUtils.ToDetail(obj.iconData))
        end)
    end
    self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.RootIconView, onCreateItem)
    self.uiScroll:Resize(self.model.resourceList:Count())


end
function UIPopupNotificationRewardView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    self:OnReadyHide()
end

function UIPopupNotificationRewardView:InitButtons()
    self.config.button2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.yesCallback ~= nil then
            self.yesCallback()
        end
    end)
    self.config.background.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
    self.config.button1.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
end

function UIPopupNotificationRewardView:InitLocalization()
    self.config.textButton1.text = LanguageUtils.LocalizeCommon("no")
    self.config.textButton2.text = LanguageUtils.LocalizeCommon("yes")
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("notification")
end

--- @param data {callbackClose : function}
function UIPopupNotificationRewardView:OnReadyShow(result)
    if result ~= nil then
        self:_Init(result)
    end
    UIBaseView.OnReadyShow(self, result)
end
function UIPopupNotificationRewardView:_Init(result)
    self.model.resourceList = result.resourceList
    if (self.uiScroll ~= nil) then
        self.uiScroll:Hide()
    end
    self.listRewardInBound = result.rewardList
    self.model.textButton = result.textButton
    self.config.textNoti.text = result.titleText
    self:InitLocalization()
    if self.model.textButton == nil then
        self.model.textButton = LanguageUtils.LocalizeCommon("claim")
    end
    if result.yesCallback ~= nil then
        self.yesCallback = result.yesCallback
    end
    self.uiScroll:Resize(self.model.resourceList:Count())
end