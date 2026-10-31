
--- @class UIPopupBuyItemRaidView : UIBaseView
UIPopupBuyItemRaidView = Class(UIPopupBuyItemRaidView, UIBaseView)

--- @param model UIPopupBuyItemRaidModel
function UIPopupBuyItemRaidView:Ctor(model)
	--- @type UIPopupBuyItemRaidConfig
	self.config = nil
	---@type ItemIconView
	self.itemView = nil
	self.gemPrice = ResourceMgr.GetRaidConfig().raidConfig.turnPrice
	---@type RaidInBound
	self.raidInbound = nil
	UIBaseView.Ctor(self, model)
	--- @type UIPopupBuyItemRaidModel
	self.model = model
end

function UIPopupBuyItemRaidView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UIPopupBuyItemRaidView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonCloseLayer.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBuyAds.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBuyAds()
	end)
	self.config.buttonBuyGem.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBuyGem()
	end)
end

function UIPopupBuyItemRaidView:InitLocalization()
end

--- @param data {callbackClose : function}
function UIPopupBuyItemRaidView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.raidInbound = zg.playerData:GetMethod(PlayerDataMethod.RAID)

	self.model.data = result

	self.turnBuyInDay = self.raidInbound.turnBuyInDay:Get(self.model.data.raidModeType)
	self.turnAdsInDay = self.raidInbound.turnAdsInDay:Get(self.model.data.raidModeType)

	self:UpdateUI()
end

function UIPopupBuyItemRaidView:UpdateUI()

	self.turnBuyDailyVip = ResourceMgr.GetRaidConfig().raidConfig:GetTurnBuyDailyVip()
	self.turnAdsDailyVip = ResourceMgr.GetRaidConfig().raidConfig:GetTurnAdsDailyVip()

	self.maxCountBuyTurn = self.turnBuyDailyVip - self.turnBuyInDay
	self.maxCountAdsTurn = self.turnAdsDailyVip - self.turnAdsInDay
	self.gemPrice = ResourceMgr.GetRaidConfig().raidConfig.turnPrice

	self.config.textPriceGem.text = self.gemPrice
	self.config.textItem.text = LanguageUtils.LocalizeCommon("raid_key_" .. self.model.data.id)
	if self.itemView == nil then
		self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
		self.itemView:SetIconData(ItemIconData.CreateInstance(self.model.data.type, self.model.data.id, nil))
		self.itemView:RegisterShowInfo()
	end

	self.config.textLimitGem.text = string.format("%s %s",
			LanguageUtils.LocalizeCommon("limited"),
			string.format("%s/%s", self.maxCountBuyTurn, self.turnBuyDailyVip))

	self.config.textLimitAds.text = string.format("%s %s",
			LanguageUtils.LocalizeCommon("limited"),
			string.format("%s/%s", self.maxCountAdsTurn, self.turnAdsDailyVip))
	self.config.textBuyAds.text = LanguageUtils.LocalizeCommon("watch")

	UIUtils.SetActiveColorByMaterial(self.config.buttonBuyGem.gameObject, self.maxCountBuyTurn > 0, "ui_gray_mat")
	UIUtils.SetActiveColorByMaterial(self.config.buttonBuyAds.gameObject, self.maxCountAdsTurn > 0, "ui_gray_mat")
end

function UIPopupBuyItemRaidView:UpdateTurnBuy()
	self.turnBuyInDay = self.turnBuyInDay + 1
	self:UpdateUI()
end

function UIPopupBuyItemRaidView:UpdateTurnAds()
	self.turnAdsInDay = self.turnAdsInDay + 1
	self:UpdateUI()
end

--- @return void
function UIPopupBuyItemRaidView:OnClickBuyGem()
	if self.maxCountBuyTurn > 0 then
		if self.model.data.callbackPurchase ~= nil then
			if self.model.data.isSell then
				--PopupMgr.HidePopup(UIPopupName.UIPopupBuyItemRaid)
				self.model.data.callbackPurchase(false, self:UpdateTurnBuy())
			else
				local gemPrice = ResourceMgr.GetRaidConfig().raidConfig.turnPrice
				local canPurchase = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.model.data.moneyType, gemPrice))
				if canPurchase then
					--PopupMgr.HidePopup(UIPopupName.UIPopupBuyItemRaid)
					self.model.data.callbackPurchase(false, self:UpdateTurnBuy())
					zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
				end
			end
		end
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_buy_turn_daily"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

--- @return void
function UIPopupBuyItemRaidView:OnClickBuyAds()
	if self.maxCountAdsTurn > 0 then
		VideoRewardedUtils.SetType(1)
		VideoRewardedUtils.SetAction(function()
			--PopupMgr.HidePopup(UIPopupName.UIPopupBuyItemRaid)
			self.model.data.callbackPurchase(true, self:UpdateTurnAds())
			zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
		end)
		IapDataInBound.Validate(function()
			if VideoRewardedUtils.AllowSkipVideo() then
				VideoRewardedUtils.RequestToServer()
			else
				VideoRewardedUtils.OpenRewarded(AdsPlacement.RAID_KEY_ADS)
			end
		end)
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_ads_turn_daily"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

--- @return void
function UIPopupBuyItemRaidView:Hide()
	UIBaseView.Hide(self)
	if self.itemView ~= nil then
		self.itemView:ReturnPool()
		self.itemView = nil
	end
end