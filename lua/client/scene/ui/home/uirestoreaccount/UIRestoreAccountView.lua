---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiRestoreAccount.UIRestoreAccountConfig"

--- @class UIRestoreAccountView : UIBaseView
UIRestoreAccountView = Class(UIRestoreAccountView, UIBaseView)

--- @return void
--- @param model UIRestoreAccountModel
--- @param ctrl UIRestoreAccountCtrl
function UIRestoreAccountView:Ctor(model, ctrl)
	---@type UIRestoreAccountConfig
	self.config = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIRestoreAccountModel
	self.model = model
	--- @type UIRestoreAccountCtrl
	self.ctrl = ctrl
end

--- @return void
function UIRestoreAccountView:InitLocalization()
	self.config.titleNotice.text = LanguageUtils.LocalizeCommon("notice")
	self.config.textNoti.text = LanguageUtils.LocalizeCommon("do_you_want_restore")
	self.config.localizeLogin.text = LanguageUtils.LocalizeCommon("login")
	self.config.localizeRegister.text = LanguageUtils.LocalizeCommon("register")
	self.config.localizeRestore.text = LanguageUtils.LocalizeCommon("restore")
end

--- @return void
function UIRestoreAccountView:OnReadyCreate()
	---@type UIRestoreAccountConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonRegister.onClick:AddListener(function ()
		self:OnClickRegister()
	end)
	self.config.buttonRestore.onClick:AddListener(function ()
		self:OnClickRestore()
	end)
	self.config.buttonLogin.onClick:AddListener(function ()
		self:OnClickLogin()
	end)
end

--- @return void
function UIRestoreAccountView:OnReadyShow(data)
	if data ~= nil and data.canRestore == true then
		self.config.buttonRestore.gameObject:SetActive(true)
	else
		self.config.buttonRestore.gameObject:SetActive(false)
	end
	--if zg.playerData.guestAccountBindingInBound.listUserName:Get(1) == ""  then
	--	self.config.buttonRestore.gameObject:SetActive(true)
	--else
	--	self.config.buttonRestore.gameObject:SetActive(false)
	--end
end

--- @return void
function UIRestoreAccountView:OnReadyHide()
	PopupMgr.HidePopup(self.model.uiName)
end

--- @return void
function UIRestoreAccountView:OnClickRegister()
	local callbackClose = function()
		PopupMgr.ShowAndHidePopup(UIPopupName.UIRestoreAccount, nil, UIPopupName.UIRegisterAccount)
	end
	PopupMgr.ShowAndHidePopup(UIPopupName.UIRegisterAccount, {["callbackRegisterSuccess"] = LoginUtils.LoginComplete, ["callbackClose"] = callbackClose}, UIPopupName.UIRestoreAccount)
end

--- @return void
function UIRestoreAccountView:OnClickRestore()
	local loginSuccess = function()
		LoginUtils.LoginComplete()
		PopupMgr.HidePopup(self.model.uiName)
	end
	local loginFailed = function()
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("restore_failed"))
	end
	LoginUtils.LoginByToken(loginSuccess, loginFailed)
end

--- @return void
function UIRestoreAccountView:OnClickLogin()
	local callbackClose = function()
		PopupMgr.ShowAndHidePopup(UIPopupName.UIRestoreAccount, nil, UIPopupName.UILogin)
	end
	PopupMgr.ShowAndHidePopup(UIPopupName.UILogin, {["callbackLoginSuccess"] = LoginUtils.LoginComplete, ["callbackClose"] = callbackClose}, UIPopupName.UIRestoreAccount)
end