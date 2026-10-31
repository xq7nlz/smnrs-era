---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiChangePassword.UIChangePasswordConfig"

--- @class UIChangePasswordView : UIBaseView
UIChangePasswordView = Class(UIChangePasswordView, UIBaseView)

--- @return void
--- @param model UIChangePasswordModel
function UIChangePasswordView:Ctor(model, ctrl)
	---@type UIChangePasswordConfig
	self.config = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIChangePasswordModel
	self.model = model
end

--- @return void
function UIChangePasswordView:OnReadyCreate()
	---@type UIChangePasswordConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonConfirm.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickChangePassword()
	end)
end

--- @return void
function UIChangePasswordView:InitLocalization()
	self.config.titleChangePassword.text = LanguageUtils.LocalizeCommon("change_password")
	self.config.localizePassword.text = LanguageUtils.LocalizeCommon("password")
	self.config.localizeNewPassword.text = LanguageUtils.LocalizeCommon("new_password")
	self.config.localizeConfirmNewPassword.text = LanguageUtils.LocalizeCommon("confirm_new_password")
	self.config.localizeCancel.text = LanguageUtils.LocalizeCommon("cancel")
	self.config.localizeConfirm.text = LanguageUtils.LocalizeCommon("confirm")
	self.config.noteRegister.text = LanguageUtils.LocalizeCommon("note_register")
end

--- @return void
function UIChangePasswordView:OnReadyShow()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.config.inputPassword.text = ""
	self.config.inputNewPassword.text = ""
	self.config.inputConfirmNewPassword.text = ""
end

function UIChangePasswordView:OnClickBackOrClose()
	self:OnReadyHide()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
end

--- @return void
function UIChangePasswordView:OnClickChangePassword()
	if self.config.inputNewPassword.text == self.config.inputConfirmNewPassword.text then
		if self.config.inputNewPassword.text ~= self.config.inputPassword.text then
			if string.match(self.config.inputNewPassword.text, "%W") == nil then
				local count = #self.config.inputNewPassword.text
				if count >= 6 and count <= 20 then
					local callbackSuccess = function()
						SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
						PopupMgr.HidePopup(UIPopupName.UIChangePassword)
					end
					LoginUtils.ChangePassword(self.config.inputPassword.text, self.config.inputNewPassword.text, callbackSuccess)
				else
					SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("new_password_limit"))
					zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
				end
			else
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("new_password_contain_special"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("new_password_is_last"))
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		end
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("new_password_failed"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end