--- @class UISwitchAccountView : UIBaseView
UISwitchAccountView = Class(UISwitchAccountView, UIBaseView)

--- @return void
--- @param model UISwitchAccountModel
function UISwitchAccountView:Ctor(model)
    ---@type function
    self.callbackLoginSuccess = nil
    ---@type boolean
    self.canRegister = nil

    UIBaseView.Ctor(self, model)
    --- @type UISwitchAccountModel
    self.model = model
end

--- @return void
function UISwitchAccountView:OnReadyCreate()
    ---@type UISwitchAccountConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonLinkingFacebook.onClick:AddListener(function()
        self:OnClickLoginFacebook()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonLinkingFansipan.onClick:AddListener(function()
        self:OnClickLoginSummonerEra()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonLinkingGoogle.onClick:AddListener(function()
        self:OnClickLoginGoogle()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonLinkingApple.onClick:AddListener(function()
        self:OnClickLoginApple()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UISwitchAccountView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("login")
    self.config.localizeFacebook .text = LanguageUtils.LocalizeCommon("login_facebook")
    self.config.localizeApple.text = LanguageUtils.LocalizeCommon("sign_in_apple")
    self.config.localizeFansipan.text = LanguageUtils.LocalizeCommon("login_summoner_era")
    self.config.localizeGoogle.text = LanguageUtils.LocalizeCommon("login_google")
end

--- @return void
function UISwitchAccountView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.config.backGround.enabled = true
    self.config.buttonClose.gameObject:SetActive(true)
    --self.canCloseByBackButton = true
    if result ~= nil then
        self.callbackLoginSuccess = result.callbackLoginSuccess
        self.canRegister = result.canRegister
        --if result.canCloseByBackButton == false then
        --	self.canCloseByBackButton = false
        --	self.config.backGround.enabled = false
        --	self.config.buttonClose.gameObject:SetActive(false)
        --end
    else
        self.callbackLoginSuccess = nil
        self.canRegister = nil
    end

    if IS_IOS_PLATFORM or IS_EDITOR_PLATFORM then
        self.config.buttonLinkingApple.gameObject:SetActive(true)
        self.config.buttonLinkingGoogle.gameObject:SetActive(false)
        self.config.buttonLinkingFacebook.gameObject:SetActive(true)
    elseif IS_ANDROID_PLATFORM then
        self.config.buttonLinkingApple.gameObject:SetActive(false)
        self.config.buttonLinkingGoogle.gameObject:SetActive(true)
        self.config.buttonLinkingFacebook.gameObject:SetActive(true)
    else
        self.config.buttonLinkingApple.gameObject:SetActive(false)
        self.config.buttonLinkingGoogle.gameObject:SetActive(false)
        self.config.buttonLinkingFacebook.gameObject:SetActive(false)
    end
end

--- @return void
function UISwitchAccountView:LoginSuccess()
    PopupMgr.HidePopup(self.model.uiName)
    if self.callbackLoginSuccess ~= nil then
        self.callbackLoginSuccess()
    end
end

--- @return void
function UISwitchAccountView:OnClickLoginSummonerEra()
    local data = {
        callbackLoginSuccess = function()
            self:LoginSuccess()
        end,
        canRegister = self.canRegister == true or ((zgUnity.IsTest == true) and self.canRegister == nil)
    }
    PopupMgr.ShowPopup(UIPopupName.UILogin, data)
end

--- @return void
function UISwitchAccountView:OnClickLoginFacebook()
    LoginUtils.LoginOrRegisterByFacebook(function()
        self:LoginSuccess()
    end, SmartPoolUtils.LogicCodeNotification)
end

--- @return void
function UISwitchAccountView:OnClickLoginGoogle()
    LoginUtils.LoginOrRegisterByGoogle(function()
        self:LoginSuccess()
    end, SmartPoolUtils.LogicCodeNotification)
end

--- @return void
function UISwitchAccountView:OnClickLoginApple()
    LoginUtils.LoginOrRegisterByApple(function()
        self:LoginSuccess()
    end, SmartPoolUtils.LogicCodeNotification)
end

--- @return void
function UISwitchAccountView:OnClickLoginSunGame()
    LoginUtils.LoginOrRegisterBySunGame(function()
        self:LoginSuccess()
    end, SmartPoolUtils.LogicCodeNotification, function()
        LoginUtils.LoginOrRegisterByToken(function()
            self:LoginSuccess()
        end, SmartPoolUtils.LogicCodeNotification)
    end)
end