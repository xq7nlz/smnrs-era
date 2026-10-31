--- @class UIDeleteAccountView : UIBaseView
UIDeleteAccountView = Class(UIDeleteAccountView, UIBaseView)

--- @param model UIDeleteAccountModel
function UIDeleteAccountView:Ctor(model)
    ---@type UIDeleteAccountConfig
    self.config = nil

    UIBaseView.Ctor(self, model)
    --- @type UIDeleteAccountModel
    self.model = model
end

--- @return void
function UIDeleteAccountView:OnReadyCreate()
    ---@type UIDeleteAccountConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonNo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
    self.config.buttonYes.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickYes()
    end)
    self.config.buttonConfirm.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickConfirm()
    end)
    self.config.buttonInput.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInput()
    end)
    self.config.inputName.onEndEdit:AddListener(function(text)
        self:EndInputName()
    end)
end

--- @return void
function UIDeleteAccountView:InitLocalization()
    self.config.textTitle1.text = LanguageUtils.LocalizeCommon("delete_account")
    self.config.textTitle2.text = LanguageUtils.LocalizeCommon("delete_account")
    self.config.textPlaceHolder.text = LanguageUtils.LocalizeCommon("tap_here_to_type")
    self.config.textConfirm.text = LanguageUtils.LocalizeCommon("confirm")
    self.config.textYes.text = LanguageUtils.LocalizeCommon("yes")
    self.config.textNo.text = LanguageUtils.LocalizeCommon("no")
end

--- @return void
function UIDeleteAccountView:OnReadyShow(data)
    self.stepPage = data.stepPage
    self:UpdateLocalizeByStep(self.stepPage)
    self.config.inputName.text = ""
    self.config.popup.localPosition = U_Vector3.zero
end

--- @return void
function UIDeleteAccountView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
end

--- @return void
function UIDeleteAccountView:Hide()
    UIBaseView.Hide(self)
end

--- @return void
function UIDeleteAccountView:OnClickYes()
    PopupMgr.ShowAndHidePopup(self.model.uiName,{stepPage = 2}, self.model.uiName)
end

--- @return void
function UIDeleteAccountView:OnClickConfirm()
    if self.config.inputName.text == tostring("YES") then
        U_Application.OpenURL("https://docs.google.com/forms/d/e/1FAIpQLScZS_14DPE5aaBtxwQ7Ym3wWHz_m2Ome22dAB3oM6EstR1r9Q/viewform")
        PopupMgr.HidePopup(self.model.uiName)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("input_delete_failed"))
    end
end


function UIDeleteAccountView:UpdateLocalizeByStep(stepPage)
    self.config.step1.gameObject:SetActive(stepPage == 1)
    self.config.step2.gameObject:SetActive(stepPage == 2)
    self.config.textDeleteAccountRule1.text = LanguageUtils.LocalizeCommon("delete_account_rule_"..stepPage)
    self.config.textWarning1.text = LanguageUtils.LocalizeCommon("delete_account_warning_"..stepPage)
    self.config.textDeleteAccountRule2.text = LanguageUtils.LocalizeCommon("delete_account_rule_"..stepPage)
    self.config.textWarning2.text = LanguageUtils.LocalizeCommon("delete_account_warning_"..stepPage)
end

--- @return void
function UIDeleteAccountView:OnClickInput()
    if self.config.inputName.isFocused == false then
        self.config.inputName:Select()
        if IS_MOBILE_PLATFORM then
            DOTweenUtils.DOMove(self.config.popup.transform, self.config.positionInput.position, 0.2, U_Ease.OutBounce, nil)
        end
    end
end

--- @return void
function UIDeleteAccountView:EndInputName()
    if IS_MOBILE_PLATFORM then
        DOTweenUtils.DOMove(self.config.popup.transform, self.config.transform.position, 0.2, U_Ease.OutBounce, nil)
    end
end