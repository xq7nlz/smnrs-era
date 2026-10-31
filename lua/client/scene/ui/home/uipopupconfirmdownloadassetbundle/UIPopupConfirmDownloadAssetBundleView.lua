
--- @class UIPopupConfirmDownloadAssetBundleView : UIBaseView
UIPopupConfirmDownloadAssetBundleView = Class(UIPopupConfirmDownloadAssetBundleView, UIBaseView)

--- @param model UIPopupConfirmDownloadAssetBundleModel
function UIPopupConfirmDownloadAssetBundleView:Ctor(model)
	--- @type number
	self.totalSize = nil
	---	@type function
	self.onClickYes = nil

	--- @type UIPopupConfirmDownloadAssetBundleConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type boolean
	self.loadFromResources = true
	--- @type UIPopupConfirmDownloadAssetBundleModel
	self.model = model
end

function UIPopupConfirmDownloadAssetBundleView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UIPopupConfirmDownloadAssetBundleView:InitButtons()
	self.config.buttonYes.onClick:AddListener(function ()
		if self.onClickYes ~= nil then
			PopupMgr.HidePopup(UIPopupName.UIPopupConfirmDownloadAssetBundle)
			self.onClickYes()
		end
	end)

	self.config.buttonNo.onClick:AddListener(function ()
		local data = {}
		data.onClickYes = self.onClickYes
		PopupMgr.ShowAndHidePopup(UIPopupName.UIPopupNotificationDownloadAssetBundle, data, UIPopupName.UIPopupConfirmDownloadAssetBundle)
	end)
end

function UIPopupConfirmDownloadAssetBundleView:InitLocalization()
	self.config.textTitleContent.text = LanguageUtils.LocalizeCommon("download_asset_bundle")
	self.config.textYes.text = LanguageUtils.LocalizeCommon("yes")
	self.config.textNo.text = LanguageUtils.LocalizeCommon("no")
end

--- @param data {callbackClose : function}
function UIPopupConfirmDownloadAssetBundleView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.onClickYes = data.onClickYes
	self.totalSize = data.totalSize
	self.config.textContentConnect.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("warning_download_data"), math.floor(((self.totalSize) / 1024^2) * 100) / 100, "f1b02f")
end
