---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHiddenDeal.UIHiddenDealConfig"

--- @class UIHiddenDealView : UIBaseView
UIHiddenDealView = Class(UIHiddenDealView, UIBaseView)

--- @return void
--- @param model UIHiddenDealModel
function UIHiddenDealView:Ctor(model)
    --- @type UIHiddenDealConfig
    self.config = nil
	--- @type ItemsTableView
	self.itemsTable = nil
	--- @type IapDataInBound
	self.iapDataInBound = nil
	--- @type number
	self.timeRefresh = nil
	--- @type ConditionalPackCollection
	self.flashSalePackCollection = nil
	--- @type GroupPackOfProducts
	self.groupPackOfProducts = nil
	--- @type GroupProductConfig
	self.groupProductConfig = nil
	--- @type number
	self.packId = nil
	UIBaseView.Ctor(self, model)
    --- @type UIHiddenDealModel
    self.model = model
end

function UIHiddenDealView:OnReadyCreate()
	---@type UIHiddenDealConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
	self:InitUpdateTime()
	self.itemsTable = ItemsTableView(self.config.rewardAnchor)
end

function UIHiddenDealView:InitLocalization()
	self.config.textTapToClose.gameObject:SetActive(false)
end

function UIHiddenDealView:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self:SetTimeRefresh()
			if self.timeRefresh < 0 then
				self:CallViewClose()
			end
		else
			self.timeRefresh = self.timeRefresh - 1
		end
		self:SetTextTimeRefresh()
		if self.timeRefresh < 0 then
			self:CallViewClose()
		end
	end
end

function UIHiddenDealView:InitButtonListener()
	self.config.bgClose.onClick:AddListener(function ()
		self:OverrideOnClickBackOrClose()
	end)
	self.config.buttonBuy.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBuy()
	end)
end

--- @param data {callbackClose : function}
function UIHiddenDealView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:GetRefs()

	if self.groupProductConfig.duration > 0 then
		zg.timeMgr:AddUpdateFunction(self.updateTime)
	else
		self.config.textTimer.text = string.format("<color=#%s>%s</color>", UIUtils.color7, "Buy! You has one chance only")
	end

	self.config.textProfit.text = string.format("<color=#%s>%d%%</color> <size=%d>%s</size>", UIUtils.white, self.csv.profit, 60, LanguageUtils.LocalizeCommon("profit"))
	self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, self.packId))

	self:ShowReward()
end

function  UIHiddenDealView:GetRefs()
	self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
	--- @type ProgressPackCollection
	self.progressPackCollection = self.iapDataInBound.progressPackData
	local listActiveGroupProductConfig = self.progressPackCollection:GetListActiveGroupByViewType(PackViewType.FLASH_SALE_PACK)
	--- @type GroupProductConfig
	self.groupProductConfig = listActiveGroupProductConfig:Get(1)
	self.groupId = self.groupProductConfig.groupId

	--- Just Show the 1st pack in group
	--- @type List
	local listProductInGroup = self.groupProductConfig:GetListProductConfig()
	--- @type ProductConfig
	local firstPack = listProductInGroup:Get(1)
	self.packId = firstPack.id
	self.csv = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPackById(OpCode.PURCHASE_PROGRESS_PACK, self.packId)
end

function UIHiddenDealView:ShowReward()
	--- @type RewardInBound
	local fragmentHeroId = self.csv.rewardList:Get(1)
	local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(fragmentHeroId.id)
	local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
	self.config.textName.text = LanguageUtils.LocalizeNameHero(heroId)
	self.config.textDesc.text = LanguageUtils.LocalizeCommon("tilion_nick_name")
	self.config.iconFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, faction)

	local iconDataList = List()
	for i = 1, self.csv.rewardList:Count() do
		--- @type RewardInBound
		local resData = self.csv.rewardList:Get(i)
		iconDataList:Add(resData:GetIconData())
	end
	self.itemsTable:SetData(iconDataList, UIPoolType.RootIconView)
end

function UIHiddenDealView:OnClickBuy()
	BuyUtils.InitListener(function()
		local progressPackCollection = self.iapDataInBound.progressPackData
		progressPackCollection.activeProgressPackDict:RemoveByKey(self.groupId)
		self:OnClickBackOrClose()
		RxMgr.notificationPurchasePacks:Next()
	end, function(logicCode)
		XDebug.Error("Error logic code " .. logicCode)
	end)
	RxMgr.purchaseProduct:Next(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, self.packId))
end

function UIHiddenDealView:SetTimeRefresh()
	self.timeRefresh = self.progressPackCollection.activeProgressPackDict:Get(self.groupId) + self.groupProductConfig.duration - zg.timeMgr:GetServerTime()
end

function UIHiddenDealView:SetTextTimeRefresh()
	self.config.textTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
			UIUtils.SetColorString(UIUtils.color7, TimeUtils.SecondsToClock(self.timeRefresh)))
end

function UIHiddenDealView:OverrideOnClickBackOrClose()
	if self.groupProductConfig.duration < 0 then
		PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("warning_flash_sale"), nil, function()
			self:OnConfirmClose()
		end)
	else
		self:CallViewClose()
	end
end

function UIHiddenDealView:OnConfirmClose()
	local callback = function()
		local onIapUpdated = function()
			self:CallViewClose()
		end
		local onFailed = function()
			self:CallViewClose()
		end
		PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, onIapUpdated, onFailed)
	end
	local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, self.groupId)
	NetworkUtils.Request(OpCode.PURCHASE_FLASH_SALE_CLOSE_PACK, outBound, callback)
end

function UIHiddenDealView:CallViewClose()
	UIBaseView.OnClickBackOrClose(self)

	--zg.playerData.remoteConfig.showedFlashSaleCreatedTime = self.progressPackCollection.activeProgressPackDict:Get(self.groupId)
	zg.playerData.remoteConfig.showedFlashSaleLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
	zg.playerData:SaveRemoteConfig()
end

function UIHiddenDealView:OnReadyHide()
	PopupMgr.HidePopup(self.model.uiName)
	if self.callbackClose ~= nil then
		self.callbackClose()
	end
end

function UIHiddenDealView:RemoveUpdateTime()
	zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIHiddenDealView:Hide()
	UIBaseView.Hide(self)
	self.itemsTable:Hide()
	self:RemoveUpdateTime()
end
