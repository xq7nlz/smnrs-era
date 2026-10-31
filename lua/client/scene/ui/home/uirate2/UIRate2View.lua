---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiRate.UIRateConfig"
require "lua.client.scene.ui.home.uiRate.UIRateView"
require "lua.client.scene.ui.home.uiRate2.RateRewardConfig"
--- @class UIRate2View : UIRateView
UIRate2View = Class(UIRate2View, UIRateView)
--- @return void
--- @param model UIRate2Model
function UIRate2View:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIRate2Model
	self.model = model
	--- @type RateRewardConfig
	self.rewardConfig = RateRewardConfig()
	--- @type List
	self.listRewardItem = List()
	--- @type RatePopup
	self.currentPopup = nil
end

--- @return void
function UIRate2View:OnReadyCreate()
	---@type UIRateConfig
	self.config = UIBaseConfig(self.uiTransform)

end

function UIRate2View:OnReadyShow(result)
	self:InitButtonListener()
	self:InitLocalization()
	if result ~= nil then
		if result.tab == RatePopup.Like then
			self:ShowLikeReward()
		elseif result.tab == RatePopup.Rate then
			self:Like()
		end
	end

end

function UIRate2View:ShowLikeReward()
	self.currentPopup = RatePopup.Like
	self:ReturnPoolRewardItem()
	--- @type List
	local listReward = self.rewardConfig:GetLikeReward()
	for i = 1, listReward:Count() do
		--- @type RootIconView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
		iconView:SetIconData(listReward:Get(i):GetIconData())
		self.listRewardItem:Add(iconView)
	end
end

function UIRate2View:ShowRateReward()
	self.currentPopup = RatePopup.Rate
	self:ReturnPoolRewardItem()
	--- @type List
	local listReward = self.rewardConfig:GetRateReward()
	for i = 1, listReward:Count() do
		--- @type RootIconView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
		iconView:SetIconData(listReward:Get(i):GetIconData())
		self.listRewardItem:Add(iconView)
	end
end

--- @return void
function UIRate2View:InitButtonListener()
	self.config.buttonNotRate.onClick:RemoveAllListeners()
	self.config.buttonRate.onClick:RemoveAllListeners()
	self.config.buttonNotRate.onClick:AddListener(function()
		TrackingUtils.TrackingRating(FBProperties.LIKE_BUTTON_CLICK, "false")
		self:OnFinishStepRating(1)
		self:OnClickBackOrClose()
	end)
	self.config.buttonRate.onClick:AddListener(function()
		TrackingUtils.TrackingRating(FBProperties.LIKE_BUTTON_CLICK, "true")
		self:OnFinishStepRating(1)
		self:Like()
	end)
end

--- @return void
function UIRate2View:OnFinishStepRating(stepId)
	print("function UIRate2View:OnFinishStepRating(stepId)")
	print(stepId)
	local OnReceived = function(result)
		--- @type List
		local rewards = List()
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			rewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
		end
		local onSuccess = function()
			if rewards:Count() > 0 then
				PopupUtils.ClaimAndShowRewardList(rewards)
			end
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end

	NetworkUtils.Request(OpCode.HERO_SUMMON_RATING_REWARD, UnknownOutBound.CreateInstance(PutMethod.Int, stepId), OnReceived)
end

function UIRate2View:Like()
	self.config.localizeRateContent.text = LanguageUtils.LocalizeCommon("rate_content_2")
	self.config.localizeNotRate.text = LanguageUtils.LocalizeCommon("not_now")
	self.config.localizeRate.text = LanguageUtils.LocalizeCommon("rate")
	self:ShowRateReward()
	self.config.buttonNotRate.onClick:RemoveAllListeners()
	self.config.buttonRate.onClick:RemoveAllListeners()
	self.config.buttonNotRate.onClick:AddListener(function()
		TrackingUtils.TrackingRating(FBProperties.RATE_BUTTON_CLICK, "false")
		self:OnFinishStepRating(2)
		self:OnClickBackOrClose()
	end)
	self.config.buttonRate.onClick:AddListener(function()
		TrackingUtils.TrackingRating(FBProperties.RATE_BUTTON_CLICK, "true")
		self:OnFinishStepRating(2)
		self:GoRate()
	end)
	UserRate.SaveLikeToServer(-1)
end

function UIRate2View:GoRate()
	PopupMgr.HidePopup(UIPopupName.UIRate2)
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
end

function UIRate2View:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	PopupMgr.ShowAndHidePopup(UIPopupName.UIRateFeedback, nil, UIPopupName.UIRate2)
	if self.currentPopup == RatePopup.Like then
		UserRate.SaveLikeToServer(-1)
	else
		UserRate.SaveRateToServer(-1)
	end
end

--- @return void
function UIRate2View:InitLocalization()
	self.config.localizeRateTitle.text = LanguageUtils.LocalizeCommon("rate_title_1")
	self.config.localizeRateContent.text = LanguageUtils.LocalizeCommon("rate_content_1")
	self.config.localizeRate.text = LanguageUtils.LocalizeCommon("i_like_it")
	self.config.localizeNotRate.text = LanguageUtils.LocalizeCommon("need_improvements")
end

function UIRate2View:ReturnPoolRewardItem()
	for i = 1, self.listRewardItem:Count() do
		self.listRewardItem:Get(i):ReturnPool()
	end
	self.listRewardItem:Clear()
end

function UIRate2View:Hide()
	self:ReturnPoolRewardItem()
	UIRateView.Hide(self)
end


--- @class RatePopup
RatePopup ={
	Like = 1,
	Rate = 2
}