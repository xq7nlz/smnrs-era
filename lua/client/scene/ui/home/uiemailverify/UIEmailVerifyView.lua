--- @class UIEmailVerifyView : UIBaseView
UIEmailVerifyView = Class(UIEmailVerifyView, UIBaseView)

--- @return void
--- @param model UIEmailVerifyModel
function UIEmailVerifyView:Ctor(model)
	--- @type UIEmailVerifyConfig
	self.config = nil
	self.isVerifyEmail = nil
	self.callbackVerifySuccess = nil

	UIBaseView.Ctor(self, model)
	--- @type UIEmailVerifyModel
	self.model = model
end

--- @return void
function UIEmailVerifyView:OnReadyCreate()
	---@type UIEmailVerifyConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonConfirm.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickConfirm()
	end)
end

--- @return void
function UIEmailVerifyView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("email_verify")
	self.config.localizeConfirm.text = LanguageUtils.LocalizeCommon("confirm")
	self.config.localizeEmail.text = LanguageUtils.LocalizeCommon("email")
	self.config.localizeEmailInput.text = LanguageUtils.LocalizeCommon("email_verify")
end

--- @return void
function UIEmailVerifyView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	if data ~= nil then
		self.callbackVerifySuccess = data.verifySuccess
		self.isVerifyEmail = data.isVerifyEmail
	end
	self.config.inputField.text = ""
end

--- @return void
function UIEmailVerifyView:Hide()
	UIBaseView.Hide(self)
	self.callbackVerifySuccess = nil
	self.isVerifyEmail = nil
	self.config.inputField.text = ""
end

--- @return void
function UIEmailVerifyView:OnClickConfirm()
	local confirm = function()
		local mail = self.config.inputField.text
		if self.isVerifyEmail == true then
			if mail ~= nil and mail ~= "" then
				UIEmailVerifyView.RequestAddEmailVerify(mail, function ()
					local data = {}
					data.resend = function(success, failed)
						UIEmailVerifyView.RequestResendEmailVerify(success, failed)
					end
					data.confirm = function(codeVerify)
						UIEmailVerifyView.RequestEmailVerifyCode(tonumber(codeVerify),function ()
							---@type AuthenticationInBound
							local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
							if authenticationInBound ~= nil then
								authenticationInBound.email = mail
								authenticationInBound.emailState = EmailState.VERIFIED
							end
							--zg.playerData:GetEmailStatusInBound().emailState = EmailState.VERIFIED
							if self.callbackVerifySuccess ~= nil then
								self.callbackVerifySuccess()
							end
							SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("verify_email_success"))
							PopupMgr.HidePopup(UIPopupName.UICodeVerify)
							PopupMgr.HidePopup(UIPopupName.UIEmailVerify)
						end, SmartPoolUtils.LogicCodeNotification)
					end
					data.timeResend = 30
					PopupMgr.ShowPopup(UIPopupName.UICodeVerify, data)
				end, SmartPoolUtils.LogicCodeNotification)
			else
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_mail"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
		else
			if mail ~= nil and mail ~= "" then
				UIEmailVerifyView.RequestEmailForgetPassword(mail, function ()
					local data = {}
					data.resend = function(success, failed)
						UIEmailVerifyView.RequestEmailResendPassword(mail, success, failed)
					end
					data.confirm = function(code)
						--if MathUtils.IsNumber(code) then
						PopupMgr.HidePopup(UIPopupName.UICodeVerify)
						PopupMgr.ShowAndHidePopup(UIPopupName.UINewPassword, {["mail"] = mail, ["code"] = tonumber(code)}, UIPopupName.UIEmailVerify)
						--else
						--	SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("input_code_fail"))
						--end
					end
					data.timeResend = 30
					PopupMgr.ShowPopup(UIPopupName.UICodeVerify, data)
				end, SmartPoolUtils.LogicCodeNotification)
			else
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_mail"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
		end
	end

	if zg.networkMgr.isLogin == false then
		NetworkUtils.WaitForHandShake(confirm)
	else
		confirm()
	end
end

--- @param callbackSuccess function
--- @param callbackFailed function
function UIEmailVerifyView.RequestAddEmailVerify(email, callbackSuccess, callbackFailed)
	NetworkUtils.RequestAndCallback(OpCode.PLAYER_EMAIL_ADD, UnknownOutBound.CreateInstance(PutMethod.String, email), callbackSuccess, callbackFailed)
end

--- @param callbackSuccess function
--- @param callbackFailed function
function UIEmailVerifyView.RequestResendEmailVerify(callbackSuccess, callbackFailed)
	NetworkUtils.RequestAndCallback(OpCode.PLAYER_EMAIL_RESEND, nil, callbackSuccess, callbackFailed)
end

--- @param codeVerify number
--- @param callbackSuccess function
--- @param callbackFailed function
function UIEmailVerifyView.RequestEmailVerifyCode(codeVerify, callbackSuccess, callbackFailed)
	if codeVerify ~= nil then
		NetworkUtils.RequestAndCallback(OpCode.PLAYER_EMAIL_VERIFY, UnknownOutBound.CreateInstance(PutMethod.Int, codeVerify),
				callbackSuccess, callbackFailed)
	end
end

--- @param mail string
--- @param callbackSuccess function
--- @param callbackFailed function
function UIEmailVerifyView.RequestEmailForgetPassword(mail, callbackSuccess, callbackFailed)
	NetworkUtils.RequestAndCallback(OpCode.PLAYER_PASSWORD_FORGOT, UnknownOutBound.CreateInstance(PutMethod.String, mail),
			callbackSuccess, callbackFailed)
end

--- @param mail string
--- @param callbackSuccess function
--- @param callbackFailed function
function UIEmailVerifyView.RequestEmailResendPassword(mail, callbackSuccess, callbackFailed)
	NetworkUtils.RequestAndCallback(OpCode.PLAYER_PASSWORD_FORGOT_RESEND, UnknownOutBound.CreateInstance(PutMethod.String, mail),
			callbackSuccess, callbackFailed)
end