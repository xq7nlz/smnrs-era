---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiNewPassword.UINewPasswordConfig"

--- @class UINewPasswordView : UIBaseView
UINewPasswordView = Class(UINewPasswordView, UIBaseView)

--- @return void
--- @param model UINewPasswordModel
--- @param ctrl UINewPasswordCtrl
function UINewPasswordView:Ctor(model, ctrl)
	---@type UINewPasswordConfig
	self.config = nil
	self.email = nil
	self.code = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UINewPasswordModel
	self.model = model
	--- @type UINewPasswordCtrl
	self.ctrl = ctrl
end

--- @return void
function UINewPasswordView:OnReadyCreate()
	---@type UINewPasswordConfig
	self.config = UIBaseConfig(self.uiTransform)

	-- FIXED bgNone popup
	--- @type UnityEngine_Transform
	local bgNone = self.config.transform:Find("bg_none")
	if bgNone ~= nil then
		UIUtils.SetAnchor(bgNone:GetComponent(ComponentName.UnityEngine_RectTransform))
		bgNone.localScale = U_Vector3(100,100,1)
		bgNone:GetComponent(ComponentName.UnityEngine_UI_Button).onClick:AddListener(function ()
			self:OnClickBackOrClose()
		end)
	end


	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.config.buttonConfirm.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickConfirm()
	end)
end

--- @return void
function UINewPasswordView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("email_verify")
	self.config.localizeConfirm.text = LanguageUtils.LocalizeCommon("confirm")
	self.config.localizeNewPassword.text = LanguageUtils.LocalizeCommon("new_password")
	self.config.localizeConfirmPassword.text = LanguageUtils.LocalizeCommon("confirm_new_password")
end

--- @return void
function UINewPasswordView:OnReadyShow(data)
	self.mail = data.mail
	self.code = data.code
	self.config.newPassword.text = ""
	self.config.confirmPassword.text = ""
end

--- @return void
function UINewPasswordView:OnClickConfirm()
	if self.config.newPassword.text ~= nil and self.config.newPassword.text ~= "" then
		if self.config.newPassword.text == self.config.confirmPassword.text then
			local callbackSuccess = function()
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
				PopupMgr.HidePopup(UIPopupName.UINewPassword)
			end
			LoginUtils.ResetPassword(self.mail, self.code, self.config.newPassword.text, callbackSuccess, SmartPoolUtils.LogicCodeNotification)
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("confirm_new_password_fail"))
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		end
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_new_password"))
	end
end