---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiCodeVerify.UICodeVerifyConfig"

--- @class UICodeVerifyView : UIBaseView
UICodeVerifyView = Class(UICodeVerifyView, UIBaseView)

--- @return void
--- @param model UICodeVerifyModel
function UICodeVerifyView:Ctor(model, ctrl)
	---@type UICodeVerifyConfig
	self.config = nil
	self.callbackConfirm = nil
	self.callbackResend = nil
	self.timeResendMax = nil
	self.timeResend = nil

	self.localizeResend = ""

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UICodeVerifyModel
	self.model = model
end

--- @return void
function UICodeVerifyView:OnReadyCreate()
	---@type UICodeVerifyConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonConfirm.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickConfirm()
	end)
	self.config.buttonResend.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickResend()
	end)
end

--- @return void
function UICodeVerifyView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("code_verify")
	self.config.localizeConfirm.text = LanguageUtils.LocalizeCommon("confirm")
	self.config.localizeInputCode.text = LanguageUtils.LocalizeCommon("input_code")
	self.config.localizeNoticeCode.text = LanguageUtils.LocalizeCommon("noti_code")
	self.localizeResend = LanguageUtils.LocalizeCommon("resend")
end

--- @return void
function UICodeVerifyView:OnReadyShow(data)
	self.config.inputField.text = ""
	self.callbackConfirm = data.confirm
	self.callbackResend = data.resend
	self.timeResendMax = data.timeResend
	self:StartTimeResend()
end

--- @return void
function UICodeVerifyView:StartTimeResend()
	self.timeResend = self.timeResendMax
	UIUtils.SetInteractableButton(self.config.buttonResend, false)
	self.coroutineTimeResend = Coroutine.start(function ()
		while self.timeResend ~= nil and self.timeResend > 0 do
			self.config.localizeResend.text = string.format("%s(%s)", self.localizeResend, self.timeResend)
			coroutine.waitforseconds(1)
			self.timeResend = self.timeResend - 1
		end
		self.config.localizeResend.text = self.localizeResend
		UIUtils.SetInteractableButton(self.config.buttonResend, true)
		self.coroutineTimeResend = nil
	end)
end

--- @return void
function UICodeVerifyView:Hide()
	UIBaseView.Hide(self)
	self.callbackConfirm = nil
	self.callbackResend = nil
	self.timeResendMax = nil
	self.timeResend = nil
	if self.coroutineTimeResend ~= nil then
		Coroutine.stop(self.coroutineTimeResend)
		self.coroutineTimeResend = nil
	end
end

--- @return void
function UICodeVerifyView:OnClickConfirm()
	local code = self.config.inputField.text
	if code ~= nil and code ~= nil then
		if self.callbackConfirm ~= nil then
			self.callbackConfirm(code)
		end
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_code"))
	end
end

--- @return void
function UICodeVerifyView:OnClickResend()
	if self.callbackResend ~= nil then
		self.callbackResend(function ()
			self:StartTimeResend()
		end)
	end
end