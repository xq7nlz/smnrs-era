---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiRegisterAccount.UIRegisterAccountConfig"

--- @class UIRegisterAccountView : UIBaseView
UIRegisterAccountView = Class(UIRegisterAccountView, UIBaseView)

--- @return void
--- @param model UIRegisterAccountModel
function UIRegisterAccountView:Ctor(model, ctrl)
	---@type UIRegisterAccountConfig
	self.config = nil
	---@type function
	self.callbackRegisterSuccess = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIRegisterAccountModel
	self.model = model
end

--- @return void
function UIRegisterAccountView:InitLocalization()
	self.config.titleRegister.text = LanguageUtils.LocalizeCommon("register")
	self.config.localizePassword.text = LanguageUtils.LocalizeCommon("password")
	self.config.localizeAccount.text = LanguageUtils.LocalizeCommon("account")
	self.config.localizeConfirmPassword.text = LanguageUtils.LocalizeCommon("confirm_password")
	self.config.localizeFacebook.text = LanguageUtils.LocalizeCommon("continue_facebook")
	self.config.localizeConfirm.text = LanguageUtils.LocalizeCommon("confirm")
	self.config.localizeNoteText.text = LanguageUtils.LocalizeCommon("note_register")
end

--- @return void
function UIRegisterAccountView:OnReadyCreate()
	---@type UIRegisterAccountConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.inputAccount.characterLimit = ResourceMgr.GetBasicInfo().maxCharacterOfName
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonFacebook.onClick:AddListener(function ()
		self:OnClickRegisterByFacebook()
	end)
	self.config.buttonFacebook.gameObject:SetActive(false)
	self.config.buttonRegist.onClick:AddListener(function ()
		self:OnClickRegister()
	end)
	self.config.buttonRegist.transform.localPosition = U_Vector3(0, self.config.buttonRegist.transform.localPosition.y, self.config.buttonRegist.transform.localPosition.z)
end

--- @return void
--- @param result EquipmentType
function UIRegisterAccountView:Init(result)
	if result ~= nil then
		---@type boolean
		self.isBindingAccount = result.isBindingAccount
		self.callbackRegisterSuccess = result.callbackRegisterSuccess
	else
		self.callbackRegisterSuccess = nil
	end
end

--- @return void
function UIRegisterAccountView:OnReadyShow(result)
	self.config.inputAccount.text = ""
	self.config.inputPassword.text = ""
	self.config.inputConfirmPassword.text = ""
	self:Init(result)
end

--- @return void
function UIRegisterAccountView:RegisterSuccess()
	PopupMgr.HidePopup(UIPopupName.UIRegisterAccount)
	RxMgr.registerSuccess:Next()
	SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("register_account_success"))
	if self.callbackRegisterSuccess ~= nil then
		self.callbackRegisterSuccess()
	end
end

--- @return void
function UIRegisterAccountView:OnClickRegister()
	local countAccount = #self.config.inputAccount.text
	if countAccount >= ResourceMgr.GetBasicInfo().minCharacterOfName and countAccount <= ResourceMgr.GetBasicInfo().maxCharacterOfName then
		if self.config.inputPassword.text == self.config.inputConfirmPassword.text then
			if string.match(self.config.inputPassword.text, "%W") == nil then
				local count = #self.config.inputPassword.text
				if count >= 6 and count <= 20 then
					local callbackSuccess = function()
						self:RegisterSuccess()
					end
					if self.isBindingAccount == true then
						LoginUtils.BindAccountByUP(self.config.inputAccount.text, self.config.inputPassword.text, function ()
							---@type AuthenticationInBound
							local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
							authenticationInBound.userName = self.config.inputAccount.text
							callbackSuccess()
						end , SmartPoolUtils.LogicCodeNotification)
					else
						local register = function()
							LoginUtils.RegisterByUP(self.config.inputAccount.text, self.config.inputPassword.text,
									ServerListInBound.GetServerRegister(), callbackSuccess, SmartPoolUtils.LogicCodeNotification)
						end
						register()
						---@type ServerListInBound
						--local serverListInBound = zg.playerData:GetServerListInBound()
						--if serverListInBound ~= nil and serverListInBound.serverDict ~= nil and serverListInBound.serverDict:Count() > 0 then
						--	register()
						--else
						--	ServerListInBound.Request(register)
						--end
					end
				else
					SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("new_pass_limit"), "6-20"))
					zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
				end
			else
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("new_pass_special"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("confirm_pass_fail"))
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		end
	else
		SmartPoolUtils.ShowShortNotification(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("account_limit_character"),
				ResourceMgr.GetBasicInfo().minCharacterOfName , ResourceMgr.GetBasicInfo().maxCharacterOfName))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

--- @return void
function UIRegisterAccountView:OnClickRegisterByFacebook()
	--FacebookMgr.Login(function (userId)
	--	local callbackSuccess = function()
	--		self:RegisterSuccess()
	--	end
	--	if self.isBindingAccount == true then
	--		LoginUtils.BindAccountByMethod(AuthMethod.BIND_ACCOUNT_BY_FACEBOOK, userId, callbackSuccess, SmartPoolUtils.LogicCodeNotification)
	--	else
	--		LoginUtils.Register(RegisterByMethodOutBound(AuthMethod.REGISTER_BY_FACEBOOK, userId,
	--				ServerListInBound.GetServerRegister()), callbackSuccess, SmartPoolUtils.LogicCodeNotification)
	--	end
	--end)
end