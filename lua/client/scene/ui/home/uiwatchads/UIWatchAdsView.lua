---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiWatchAds.UIWatchAdsConfig"

--- @class UIWatchAdsView : UIBaseView
UIWatchAdsView = Class(UIWatchAdsView, UIBaseView)

--- @return void
--- @param model UIWatchAdsModel
function UIWatchAdsView:Ctor(model)
	--- @type UIWatchAdsConfig
	self.config = nil
	---@type UILoopScroll
	self.uiScroll = nil
	---@type List
	self.listReward = nil
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIWatchAdsModel
	self.model = model
end

--- @return void
function UIWatchAdsView:OnReadyCreate()
	---@type UIWatchAdsConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonCancel.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.config.bgButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.config.buttonPlayVideo.onClick:AddListener(function ()
		self:OnClickPlayVideo()
	end)

	--- @param obj RootIconView
	--- @param index number
	local onUpdateItem = function(obj, index)
		---@type RewardInBound
		local reward = self.listReward:Get(index + 1)
		obj:SetIconData(reward:GetIconData())
	end
	--- @param obj RootIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		obj:SetSize(150, 150)
		onUpdateItem(obj, index)
		obj:RegisterShowInfo()
	end
	self.uiScroll = UILoopScroll(self.config.item, UIPoolType.RootIconView, onCreateItem, onUpdateItem)
end

--- @return void
function UIWatchAdsView:InitLocalization()
	self.config.localizeNotice.text = LanguageUtils.LocalizeCommon("notification")
	self.config.localizeCancel.text = LanguageUtils.LocalizeCommon("cancel")
	self.config.localizePlayVideo.text = LanguageUtils.LocalizeCommon("play_video")
	self.config.localizeContent.text = LanguageUtils.LocalizeCommon("notice_watch_ads")
	self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIWatchAdsView:OnReadyShow()
	--- @type VideoRewardedInBound
	local videoData = zg.playerData:GetMethod(PlayerDataMethod.REWARD_VIDEO)
	self.listReward = ResourceMgr.GetVideoRewardedConfig():GetPrize(videoData.numberVideoView + 1)
	if self.listReward ~= nil then
		self.uiScroll.scroll.enabled = true
		self.uiScroll:Resize(self.listReward:Count())
		Coroutine.start(function()
			coroutine.waitforendofframe()
			coroutine.waitforendofframe()
			if self.listReward:Count() <= 4 then
				self.uiScroll.scroll.enabled = false
			end
		end)
	else
		XDebug.Error(string.format("Number video is invalid: %d", videoData.numberVideoView))
	end
end

--- @return void
function UIWatchAdsView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

--- @return void
function UIWatchAdsView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	PopupMgr.HidePopup(UIPopupName.UIWatchAds)
end

--- @return void
function UIWatchAdsView:OnClickPlayVideo()
	PopupMgr.HidePopup(UIPopupName.UIWatchAds)
	TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.MAIN_FEATURES, "watch_video", 1)
	VideoRewardedUtils.OpenRewarded()
end