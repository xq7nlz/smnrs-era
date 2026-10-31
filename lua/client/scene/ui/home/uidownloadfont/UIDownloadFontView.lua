
--- @class UIDownloadFontView : UIBaseView
UIDownloadFontView = Class(UIDownloadFontView, UIBaseView)

--- @return void
--- @param model UIDownloadFontModel
function UIDownloadFontView:Ctor(model)
	--- @type boolean
	self.state = true
	--- @type boolean
	self.isComplete = false

	UIBaseView.Ctor(self, model)
	--- @type UIDownloadFontModel
	self.model = model
	--- @type boolean
	self.canCloseByBackButton = false
end

--- @return void
function UIDownloadFontView:OnReadyCreate()
	---@type UIDownloadAssetBundleConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.barPercent = UIBarPercentView(self.config.barPercent)

	self:InitButtonListener()
end

function UIDownloadFontView:InitButtonListener()
	self.config.buttonRetry.onClick:AddListener(function ()
		self:SetButtonRetryState(false)
		self:UpdateView()
		self:DownloadFont()
	end)
	self.config.buttonSupport.onClick:AddListener(function ()
		PopupUtils.OpenFanpage()
	end)
end

--- @return void
function UIDownloadFontView:InitLocalization()
	self.config.textTitleContent.text = LanguageUtils.LocalizeCommon("download_asset_bundle")
	self.config.textRetry.text = LanguageUtils.LocalizeCommon("retry")
	self.config.textSupport.text = LanguageUtils.LocalizeCommon("support")
end

--- @return void
function UIDownloadFontView:OnReadyShow(result)
	self.language = PlayerSettingData.language
	self.callbackOnClose = result
	self.downloadSize = bundleDownloader:GetFontSize(self.language)
	self:UpdateConnectText()
	self:UpdateView()
	self:DownloadFont()
end

--- @return void
function UIDownloadFontView:DownloadFont()
	self:SetState(true)
	bundleDownloader:DownloadFont(self.language, function()
		self.isComplete = true
	end, function()
		self:StopCoroutine()
		self:SetButtonRetryState(true)
		self:SetState(false)
	end)
end

function UIDownloadFontView:UpdateConnectText()
	self.config.textContentConnect.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("warning_download_data"), self.downloadSize, "f1b02f")
end

function UIDownloadFontView:SetButtonRetryState(isActive)
	self.config.buttonRetry.enabled = isActive
	UIUtils.SetActiveColor(self.config.buttonRetry.gameObject, isActive)
end

--- @param connected boolean
function UIDownloadFontView:SetState(connected)
	if self.state == connected then
		return
	end
	self.state = connected
	self.config.connect:SetActive(connected)
	self.config.disconnect:SetActive(not connected)
end

function UIDownloadFontView:UpdateView()
	self.coroutine = Coroutine.start(function()
		self:SetProcess(0, 0, self.downloadSize)
		local count = 1
		while count < 100 do
			coroutine.waitforendofframe()
			if count < 80 or self.isComplete then
				count = count + 1
				self:SetProcess(count/100, self.downloadSize * count / 100, self.downloadSize)
			end
		end
		FontUtils.RemoveFont(self.language)
		if self.callbackOnClose then
			self.callbackOnClose()
		end
		PopupMgr.HidePopup(self.model.uiName)
	end)
end

function UIDownloadFontView:StopCoroutine()
	if self.coroutine then
		Coroutine.stop(self.coroutine)
		self.coroutine = nil
	end
end

function UIDownloadFontView:SetProcess(percent, downloadMB, totalMB)
	self.barPercent:SetPercent(percent)
	self.config.textDownloading.text = string.format("Downloading %.2f/%.2f (MB)", downloadMB, totalMB)
end

function UIDownloadFontView:Hide()
	self:StopCoroutine()
	UIBaseView.Hide(self)
end

