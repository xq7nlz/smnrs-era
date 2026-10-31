---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiFriendMail.UIFriendMailConfig"
require "lua.client.core.network.mail.ComposeMailOutBound"

--- @class UIFriendMailView : UIBaseView
UIFriendMailView = Class(UIFriendMailView, UIBaseView)

--- @return void
--- @param model UIFriendMailModel
function UIFriendMailView:Ctor(model)
	---@type UIFriendMailConfig
	self.config = nil
	---@type ComposeMailOutBound
	self.composeMailOutBound = ComposeMailOutBound()
	---@type number
	self.lastTimeSendMail = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIFriendMailModel
	self.model = model
end

--- @return void
function UIFriendMailView:OnReadyCreate()
	---@type UIFriendMailConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.inputFieldUID.characterLimit = 40
	self.config.inputFieldContent.characterLimit = 400
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSend.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSend()
	end)
end

function UIFriendMailView:InitLocalization()
	self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("send_mail")
	self.config.localizeButton.text = LanguageUtils.LocalizeCommon("send")
end

--- @return void
function UIFriendMailView:OnReadyShow(data)
	self.config.inputFieldUID.text = ""
	self.config.inputFieldContent.text = ""
	if data ~= nil and data.id ~= nil then
		self.composeMailOutBound:SetId(data.id)
	end
end

--- @return void
function UIFriendMailView:OnClickSend()
	if self.config.inputFieldUID.text ~= nil then
		if self.config.inputFieldContent.text ~= nil then
			self.composeMailOutBound.subject = self.config.inputFieldUID.text
			self.composeMailOutBound.content = self.config.inputFieldContent.text
			local callbackSuccess = function()
				self.lastTimeSendMail = zg.timeMgr:GetServerTime()
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_success"))
				PopupMgr.HidePopup(UIPopupName.UIFriendMail)
			end
			local callbackFailed = function()
				if self.lastTimeSendMail ~= nil then
					SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("warning_send_mail"), 30 - (zg.timeMgr:GetServerTime() - self.lastTimeSendMail)))
				else
					SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_failed"))
				end
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
			NetworkUtils.RequestAndCallback( OpCode.MAIL_COMPOSE, self.composeMailOutBound, callbackSuccess, callbackFailed)
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("mail_content"))
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		end
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_friend_id"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end