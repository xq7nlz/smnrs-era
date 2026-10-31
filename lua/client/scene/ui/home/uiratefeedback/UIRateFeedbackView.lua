---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiRateFeedback.UIRateFeedbackConfig"

--- @class UIRateFeedbackView : UIBaseView
UIRateFeedbackView = Class(UIRateFeedbackView, UIBaseView)

--- @return void
--- @param model UIRateFeedbackModel
function UIRateFeedbackView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIRateFeedbackModel
	self.model = model
end

--- @return void
function UIRateFeedbackView:OnReadyCreate()
	-- do something here
	---@type UIRateFeedbackConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtonListener()
end

--- @return void
function UIRateFeedbackView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonFanpage.onClick:AddListener(function()
		PopupMgr.HidePopup(UIPopupName.UIRateFeedback)
		PopupUtils.OpenFanpage()
	end)
end

function UIRateFeedbackView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

--- @return void
function UIRateFeedbackView:InitLocalization()
	self.config.localizeGoToFanpage.text = LanguageUtils.LocalizeCommon("go_to_fanpage")
end

--- @param content string
function UIRateFeedbackView:OnReadyShow(content)
	self.config.localizeNotRateContent.text = content or LanguageUtils.LocalizeCommon("not_rate_contain")
end