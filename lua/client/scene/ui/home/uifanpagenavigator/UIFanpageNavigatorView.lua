---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiFanpageNavigator.UIFanpageNavigatorConfig"

--- @class UIFanpageNavigatorView : UIBaseView
UIFanpageNavigatorView = Class(UIFanpageNavigatorView, UIBaseView)

--- @return void
--- @param model UIFanpageNavigatorModel
function UIFanpageNavigatorView:Ctor(model)
	---@type UIFanpageNavigatorConfig
	self.config = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIFanpageNavigatorModel
	self.model = model
end

--- @return void
function UIFanpageNavigatorView:OnReadyCreate()
	---@type UIFanpageNavigatorConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonFanpage.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickFanpage()
	end)
end

--- @return void
function UIFanpageNavigatorView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("email_verify")
	self.config.localizeFanpage.text = LanguageUtils.LocalizeCommon("fanpage")
	self.config.localizeNoticeFanpage.text = LanguageUtils.LocalizeCommon("go_to_fanpage_notice")
end

--- @return void
function UIFanpageNavigatorView:OnClickFanpage()
	PopupUtils.OpenFanpage()
end