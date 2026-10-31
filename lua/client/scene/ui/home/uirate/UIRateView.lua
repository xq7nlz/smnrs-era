---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiRate.UIRateConfig"

--- @class UIRateView : UIBaseView
UIRateView = Class(UIRateView, UIBaseView)

--- @return void
--- @param model UIRateModel
function UIRateView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIRateModel
	self.model = model
end

--- @return void
function UIRateView:OnReadyCreate()
	---@type UIRateConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtonListener()
end

--- @return void
function UIRateView:InitButtonListener()
	self.config.buttonNotRate.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonRate.onClick:AddListener(function()
		PopupMgr.HidePopup(UIPopupName.UIRate)
		if IS_IOS_PLATFORM then
			local rateNative = false
			if UnityEngine.iOS ~= nil and UnityEngine.iOS.Device ~= nil then
				rateNative = UnityEngine.iOS.Device.RequestStoreReview()
			elseif CS.RateNative ~= nil then
				rateNative = CS.RateNative.RequestStoreReview()
			end
			if rateNative == false then
				PopupUtils.GoToStore()
			end
		else
			PopupUtils.GoToStore()
		end
		UserRate.SaveRateToServer(-1)
	end)
end

function UIRateView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	PopupMgr.ShowAndHidePopup(UIPopupName.UIRateFeedback, nil, UIPopupName.UIRate)
	UserRate.SaveRateToServer(zg.timeMgr:GetServerTime())
end

--- @return void
function UIRateView:InitLocalization()
	self.config.localizeRateTitle.text = LanguageUtils.LocalizeCommon("rate_title")
	self.config.localizeRateContent.text = LanguageUtils.LocalizeCommon("rate_content")
	self.config.localizeRate.text = LanguageUtils.LocalizeCommon("rate")
	self.config.localizeNotRate.text = LanguageUtils.LocalizeCommon("not_rate")
end