
--- @class UIPopupNotificationDownloadAssetBundleView : UIBaseView
UIPopupNotificationDownloadAssetBundleView = Class(UIPopupNotificationDownloadAssetBundleView, UIBaseView)

--- @param model UIPopupNotificationDownloadAssetBundleModel
function UIPopupNotificationDownloadAssetBundleView:Ctor(model)
	---	@type function
	self.onClickYes = nil

	--- @type UIPopupNotificationDownloadAssetBundleConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type boolean
	self.loadFromResources = true
	--- @type UIPopupNotificationDownloadAssetBundleModel
	self.model = model
end

function UIPopupNotificationDownloadAssetBundleView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UIPopupNotificationDownloadAssetBundleView:InitButtons()
	self.config.buttonYes.onClick:AddListener(function ()
		if self.onClickYes ~= nil then
			PopupMgr.HidePopup(UIPopupName.UIPopupNotificationDownloadAssetBundle)
			self.onClickYes()
		end
	end)

	self.config.buttonNo.onClick:AddListener(function ()
		U_Application.Quit()
	end)
end

function UIPopupNotificationDownloadAssetBundleView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("confirm_download_asset_bundle")
	self.config.textNoti.text = LanguageUtils.LocalizeCommon("download_asset_bundle_noti")
	self.config.textButtonyes.text = LanguageUtils.LocalizeCommon("yes")
	self.config.textButtonNo.text = LanguageUtils.LocalizeCommon("no")
end

--- @param data {callbackClose : function}
function UIPopupNotificationDownloadAssetBundleView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.onClickYes = data.onClickYes
end
