--- @class UILoginView : UIBaseView
UILoginView = Class(UILoginView, UIBaseView)

--- @return void
--- @param model UILoginModel
function UILoginView:Ctor(model)
	---@type UILoginConfig
	self.config = nil
	---@type function
	self.callbackLoginSuccess = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UILoginModel
	self.model = model
end

--- @return void
function UILoginView:OnReadyCreate()
	---@type UILoginConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtonListener()
end

function UILoginView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonLogin.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickLogin()
	end)
	self.config.buttonForget.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickForget()
	end)
	self.config.buttonRegister.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickRegister()
	end)
end

--- @return void
function UILoginView:InitLocalization()
	self.config.titleLogin.text = LanguageUtils.LocalizeCommon("login")
	self.config.localizeAccount.text = LanguageUtils.LocalizeCommon("account")
	self.config.localizePassword.text = LanguageUtils.LocalizeCommon("password")
	self.config.localizeForget.text = LanguageUtils.LocalizeCommon("forget")
	self.config.localizeLogin.text = LanguageUtils.LocalizeCommon("login")
	self.config.localizeRegister.text = LanguageUtils.LocalizeCommon("register")
end

--- @return void
function UILoginView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.config.inputAccount.text = ""
	self.config.inputPassword.text = ""
	UIBaseView.OnReadyShow(self, result)
	self:InitData(result)
	self.config.buttonCloseListAccount.gameObject:SetActive(false)
	self.config.buttonListAccount.gameObject:SetActive(false)
end

--- @return void
function UILoginView:InitData(result)
	self.config.buttonRegister.gameObject:SetActive(false)
	self.config.buttonClose.gameObject:SetActive(true)
	self.config.backGround.enabled = true
	self.config.forget.sizeDelta = U_Vector2(350, 104)
	self.config.login.sizeDelta = U_Vector2(350, 104)
	

	if result ~= nil then
		self.callbackLoginSuccess = result.callbackLoginSuccess
		if result.canRegister == true then
			self.config.buttonRegister.gameObject:SetActive(true)
			self.config.forget.sizeDelta = U_Vector2(280, 104)
			self.config.login.sizeDelta = U_Vector2(280, 104)
		end

		if result.canCloseByBackButton == false then
			self.config.backGround.enabled = false
			self.config.buttonClose.gameObject:SetActive(false)
		end
	else
		self.callbackLoginSuccess = nil
	end
end

--- @return void
function UILoginView:LoginSuccess()
	if self.callbackLoginSuccess ~= nil then
		self.callbackLoginSuccess()
	end
	PopupMgr.HidePopup(self.model.uiName)
end

function UILoginView:IsCurrentAccount()
	---@type AuthenticationInBound
	local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
	return zg.networkMgr.isLogin == true and authenticationInBound ~= nil and self.config.inputAccount.text == authenticationInBound.userName
end

function UILoginView:IsValidFormatUserName()
	return self.config.inputAccount.text ~= nil and self.config.inputAccount.text ~= ""
end

function UILoginView:IsValidFormatPassword()
	return self.config.inputPassword.text ~= nil and self.config.inputPassword.text ~= ""
end

--- @return void
function UILoginView:OnClickLogin()
	if self:IsValidFormatUserName() then
		if self:IsCurrentAccount() then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("login_current_account"))
		else
			if self:IsValidFormatPassword() then
				local callbackSuccess = function()
					self:LoginSuccess()
				end
				local userName = self.config.inputAccount.text
				local passwordHash = SHA2.shaHex256(self.config.inputPassword.text)
				LoginUtils.LoginByUPHash(userName, passwordHash, callbackSuccess, function (logicCode)
					self:OnFailedLogin(logicCode)
				end)
			else
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("input_password_failed"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
		end
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("input_user_name_failed"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

--- @return void
function UILoginView:OnClickForget()
	local yesCallback = function()
		PopupMgr.ShowPopup(UIPopupName.UIEmailVerify)
	end
	local noCallback = function()
		PopupMgr.ShowPopup(UIPopupName.UIFanpageNavigator)
	end
	PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("have_verified_email"), noCallback, yesCallback)
end

--- @return void
function UILoginView:OnClickRegister()
	PopupMgr.ShowPopup(UIPopupName.UIRegisterAccount, {["callbackRegisterSuccess"] = function ()
		self:LoginSuccess()
	end})
end

--- @param logicCode LogicCode
function UILoginView:OnFailedLogin(logicCode)
	if logicCode == LogicCode.AUTH_PLAYER_BANNED then
		PopupMgr.ShowPopup(UIPopupName.UIRateFeedback, LanguageUtils.LocalizeCommon("player_banned"))
	elseif logicCode == LogicCode.AUTH_PLAYER_DEACTIVATED then
		PopupMgr.ShowPopup(UIPopupName.UIRateFeedback, LanguageUtils.LocalizeCommon("player_deactivated"))
	else
		SmartPoolUtils.LogicCodeNotification(logicCode)
	end
end