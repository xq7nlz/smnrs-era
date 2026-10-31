---COMMENT_CONFIG    require "lua.client.scene.ui.instant.uiNewUpdate.NewUpdateConfig"

--- @class UINewUpdateView : UIBaseView
UINewUpdateView = Class(UINewUpdateView, UIBaseView)

--- @return void
--- @param model UINewUpdateModel
--- @param ctrl UINewUpdateCtrl
function UINewUpdateView:Ctor(model, ctrl)
    --- @type NewUpdateConfig
    self.config = nil
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UINewUpdateModel
    self.model = model
    --- @type UINewUpdateCtrl
    self.ctrl = ctrl
    --- @type
    self.countTimeCoroutine = nil
end

--- @return void
function UINewUpdateView:OnReadyCreate()
    ---@type NewUpdateConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
end

--- @return void
function UINewUpdateView:OnReadyShow(result)
    TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.ShowPopupNewUpdate)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
end

--- @return void
function UINewUpdateView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("notice")
    self.config.textNoti.text = StringUtils.FormatLocalize(string.format(LanguageUtils.LocalizeCommon("notice_content"), VERSION), LanguageUtils.LocalizeCommon("wiki"))
    --.config.textNoti.text = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("notice_content"),LanguageUtils.LocalizeCommon("first_time_reward"),LanguageUtils.LocalizeCommon("free_gem"),LanguageUtils.LocalizeCommon("quick_battle"))
end

--- @return void
function UINewUpdateView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBackground.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UINewUpdateView:SetContent()
    self.config.textNoti.text = self.model.content
end

--- @return void
function UINewUpdateView:Hide()
    TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.ClosePopupNewUpdate)
    UIBaseView.Hide(self)
end

