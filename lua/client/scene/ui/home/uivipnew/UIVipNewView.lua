require "lua.client.data.Vip.VipBenefitData"
--- @class UIVipNewView : UIBaseView
UIVipNewView = Class(UIVipNewView, UIBaseView)

--- @return void
--- @param model UIVipModel
function UIVipNewView:Ctor(model)
	--- @type UIVipNewConfig
	self.config = nil
	---@type List --ItemView
	self.listDescription = List()
	---@type ItemsTableView
	self.rewardVipInstantView = nil
	---@type ItemsTableView
	self.rewardVipDailyBonusView = nil
	---@type number
	self.currentVipPreview = 1

	--- @type number
	self.delta = 1500
	--- @type number
	self.timeMove = 0.4
	--- @type number
	self.moving = false
	---@type UIBarPercentView
	self.process = nil

	---@type UILoopScroll
	self.scrollVipBenefit = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIVipModel
	self.model = model
end

--- @return void
function UIVipNewView:OnReadyCreate()
	---@type UIVipNewConfig
	self.config = UIBaseConfig(self.uiTransform)
	---@type UIBarPercentView
	self.process = UIBarPercentView(self.config.process)
	---@type ItemsTableView
	self.rewardVipInstantView = ItemsTableView(self.config.rewardAnchor)
	---@type ItemsTableView
	self.rewardVipDailyBonusView = ItemsTableView(self.config.rewardDailyAnchor)

	self:InitVipBenefitScroll()
	self:InitVipTabs()

	self.config.buttonShop.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "iap_shop")
		PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, nil, UIPopupName.UIVipNew)
	end)
	self.config.backButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIVipNewView:OnReadyShow()
	self.currentVipPreview = math.max(zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel, 1)
	self:CheckVip()
	self:SelectTabVip(self.currentVipPreview)
	self:ShowVipProcess(self.currentVipPreview)
end

--- @return void
function UIVipNewView:InitLocalization()
	self.config.textShop.text = LanguageUtils.LocalizeCommon("shop")
	self.config.textVipCurrent.text = LanguageUtils.LocalizeCommon("vip_full")
	self.config.textVipFull.text = LanguageUtils.LocalizeCommon("vip_full")
	self.config.textVipInstantReward.text = LanguageUtils.LocalizeVip("vip_instant")
	self.config.textVipDailyReward.text = LanguageUtils.LocalizeVip("vip_daily")

	self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIVipNewView:Hide()
	UIBaseView.Hide(self)
end

--- @return void
function UIVipNewView:CheckVip()
	---@type number
	self.currentVip = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
end

--- @return void
function UIVipNewView:ShowVipProcess(vipLevel)
	local vipPoint = InventoryUtils.GetMoney(MoneyType.VIP_POINT)
	self.config.textVipCurrent.text = string.format( LanguageUtils.LocalizeVip("current_vip"), self.currentVip)
	self.config.iconVipCurrent.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, self.currentVip)
	self.config.iconVipCurrent:SetNativeSize()

	local nextVipLevel = math.max(vipLevel,self.currentVip + 1)
	local nextVip = ResourceMgr.GetVipConfig():GetBenefits(nextVipLevel)
	local enableNextVip = (nextVip ~= nil)
	self.config.iconVipNext.gameObject:SetActive(enableNextVip)
	self.config.textVipPoint.gameObject:SetActive(enableNextVip)
	self.config.textVipFull.gameObject:SetActive(not enableNextVip)
	if enableNextVip then
		self.config.iconVipNext.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, nextVipLevel)
		self.config.iconVipNext:SetNativeSize()
		self.config.textVipPoint.text = string.format(LanguageUtils.LocalizeCommon("get_vip_point_to_reach"), UIUtils.SetColorString(UIUtils.color2, nextVip.vipPointRequired - vipPoint))

		local percent = MathUtils.Clamp(vipPoint / nextVip.vipPointRequired, 0, 1)
		self.process:SetValue(percent)
		self.process:SetText(string.format("%s/%s", vipPoint, nextVip.vipPointRequired))
	else
		self.process:SetValue(1)
		self.process:SetText(LanguageUtils.LocalizeCommon("max"))
	end
end

--- @param benefitData VipBenefitData
function UIVipNewView:CheckStateBenefit(previousBenefit, currentBenefit)
	if previousBenefit == 0 then
		return VipBenefitState.NEW
	elseif previousBenefit < currentBenefit then
		return VipBenefitState.UPGRADE
	end
	return VipBenefitState.NO_CHANGE
end

--- @return UnityEngine_RectTransform, List
--- @param vipLevel number
function UIVipNewView:ViewVip(vipLevel)
	local index = 0;

	self.listDescription:Clear()
	self.rewardVipInstantView:Hide()
	self.rewardVipDailyBonusView:Hide()

	self.config.textVipPreview.text = LanguageUtils.LocalizeVip("vip_" .. vipLevel)
--[[	self.config.iconVipPreview.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, vipLevel)
	self.config.iconVipPreview:SetNativeSize()]]

	---@type List
	local vipRewardInstantList = ResourceMgr.GetVipRewardInstant():GetListRewardByVipLevel(vipLevel)
	---@type List
	local vipRewardDailyList = ResourceMgr.GetVipRewardDaily():GetListRewardByVipLevel(vipLevel)
	---@type VipData
	local vipCurrentConfig = ResourceMgr.GetVipConfig():GetBenefits(vipLevel)
	---@type VipData
	local vipPreviousConfig = nil
	if vipLevel > 0 then
		---@type VipData
		vipPreviousConfig = ResourceMgr.GetVipConfig():GetBenefits(vipLevel - 1)
	end

	local addProperty = function (key, property, vipState)
		index = index + 1
		local content = string.format(LanguageUtils.LocalizeVip(key), UIUtils.SetColorString(UIUtils.green_light, property))
		---@type VipBenefitData
		local description = VipBenefitData.CreateByParams(index, content, vipState)
		self.listDescription:Add(description)
	end

	if vipRewardInstantList ~= nil and vipRewardInstantList:Count() > 0 then
		self.rewardVipInstantView:SetData(vipRewardInstantList, UIPoolType.RootIconView)
		self.rewardVipInstantView:SetSize(165,165)
		self.rewardVipInstantView:ActiveMaskSelect( self.currentVip - vipLevel >= 0, UIUtils.sizeItem)
	end

	if vipRewardDailyList ~= nil and vipRewardDailyList:Count() > 0 then
		local duration = zg.playerData:GetMethod(PlayerDataMethod.IAP):GetDurationInSubscriptionPack(4) or 0
		self.rewardVipDailyBonusView:SetData(vipRewardDailyList, UIPoolType.RootIconView)
		self.rewardVipDailyBonusView:SetSize(165, 165)
		self.rewardVipDailyBonusView:ActiveMaskSelect( self.currentVip - vipLevel >= 0 and duration > 0, UIUtils.sizeItem)
	end

	if vipCurrentConfig == nil then
		return
	end

	if vipCurrentConfig.autoNextBattle then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.autoNextBattle == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("auto_next_battle",nil, vipState)
	end

	if vipCurrentConfig.campaignBonusIdleTimeMax > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.campaignBonusIdleTimeMax, vipCurrentConfig.campaignBonusIdleTimeMax)
		end
		addProperty("campaign_bonus_idle_time_max", "+ " ..vipCurrentConfig.campaignBonusIdleTimeMax / TimeUtils.SecondAHour .. "h", vipState)
	end
	if vipCurrentConfig.campaignBonusGold > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.campaignBonusGold, vipCurrentConfig.campaignBonusGold)
		end
		addProperty("campaign_bonus_gold", vipCurrentConfig.campaignBonusGold * 100 .. "%", vipState)
	end
	if vipCurrentConfig.campaignBonusMagicPotion > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.campaignBonusMagicPotion, vipCurrentConfig.campaignBonusMagicPotion)
		end
		addProperty("campaign_bonus_magic_potion", vipCurrentConfig.campaignBonusMagicPotion * 100 .. "%", vipState)
	end

	if vipCurrentConfig.campaignBonusAutoTrainSlot > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.campaignBonusAutoTrainSlot, vipCurrentConfig.campaignBonusAutoTrainSlot)
		end
		addProperty("campaign_bonus_auto_train_slot", "+".. vipCurrentConfig.campaignBonusAutoTrainSlot, vipState)
	end
	if vipCurrentConfig.campaignBonusExpSummoners > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.campaignBonusExpSummoners, vipCurrentConfig.campaignBonusExpSummoners)
		end
		addProperty("campaign_bonus_exp_summoner", vipCurrentConfig.campaignBonusExpSummoners * 100 .. "%", vipState)
	end
	if vipCurrentConfig.campaignBonusQuickBattleBuyTurn > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.campaignBonusQuickBattleBuyTurn, vipCurrentConfig.campaignBonusQuickBattleBuyTurn)
		end
		addProperty("campaign_bonus_quick_battle_buy_turn", "+".. vipCurrentConfig.campaignBonusQuickBattleBuyTurn, vipState)
	end
	if vipCurrentConfig.tavernBonusQuest > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil  then
			vipState = self:CheckStateBenefit(vipPreviousConfig.tavernBonusQuest, vipCurrentConfig.tavernBonusQuest)
		end
		addProperty("tavern_bonus_quest", "+" .. vipCurrentConfig.tavernBonusQuest, vipState)
	end
	if vipCurrentConfig.raidBonusTurnBuy > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.raidBonusTurnBuy, vipCurrentConfig.raidBonusTurnBuy)
		end
		addProperty("raid_bonus_turn_buy", "+" .. vipCurrentConfig.raidBonusTurnBuy, vipState)
	end

	if vipCurrentConfig.casinoUnlockMultipleSpin then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.casinoUnlockMultipleSpin == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("casino_unlock_multiple_spin",nil, vipState)
	end

	if vipCurrentConfig.casinoUnlockPremiumSpin then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.casinoUnlockPremiumSpin == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("casino_unlock_premium_spin",nil, vipState)
	end

	if vipCurrentConfig.casinoBonusTurnBuyBasicChip > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.casinoBonusTurnBuyBasicChip, vipCurrentConfig.casinoBonusTurnBuyBasicChip)
		end
		addProperty("casino_bonus_turn_buy_basic_chip", "+".. vipCurrentConfig.casinoBonusTurnBuyBasicChip, vipState)
	end

	if vipCurrentConfig.dungeonChallengeIncreased > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.dungeonChallengeIncreased, vipCurrentConfig.dungeonChallengeIncreased)
		end
		addProperty("dungeon_challenge_increased", vipCurrentConfig.dungeonChallengeIncreased * 100 .. "%", vipState)
	end

	if vipCurrentConfig.battleUnlockSpeedUp then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.battleUnlockSpeedUp == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("battle_unlock_speed_up",nil, vipState)
	end

	if vipCurrentConfig.battleUnlockSkip then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.battleUnlockSkip == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("battle_unlock_skip",nil, vipState)
	end

	if vipCurrentConfig.battleUnlockSkipArena then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.battleUnlockSkipArena == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("battle_unlock_skip_arena",nil, vipState)
	end

	if vipCurrentConfig.summonUnlockAccumulate then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.summonUnlockAccumulate == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("summon_unlock_accumulate",nil, vipState)
	end

	if vipCurrentConfig.arenaBonusTicketBuy > 0 then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil then
			vipState = self:CheckStateBenefit(vipPreviousConfig.arenaBonusTicketBuy, vipCurrentConfig.arenaBonusTicketBuy)
		end
		addProperty("arena_bonus_ticket_buy", "+" .. vipCurrentConfig.arenaBonusTicketBuy, vipState)
	end

	if vipCurrentConfig.allowSkipAds then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.allowSkipAds == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("allow_skip_ads",nil, vipState)
	end

	if vipCurrentConfig.prophetTreeUseGem then
		local vipState = VipBenefitState.NEW
		if vipPreviousConfig ~= nil and vipPreviousConfig.prophetTreeUseGem == true then
			vipState = VipBenefitState.NO_CHANGE
		end
		addProperty("allow_prophet_tree_use_gem",nil, vipState)
	end

	self.listDescription:SortWithMethod(function(x, y)
		if x.vipState < y.vipState then
			return 1
		else
			return -1
		end
	end)

	--- @param v VipBenefitData
	for i, v in ipairs(self.listDescription:GetItems()) do
		v.index = i
	end

	self.scrollVipBenefit:Resize(self.listDescription:Count())
end

function UIVipNewView:InitVipBenefitScroll()
	--- @param obj VipBenefitDetailView
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type VipBenefitData
		local VipBenefitData = self.listDescription:Get(dataIndex)
		obj:SetData(VipBenefitData)
	end

	self.scrollVipBenefit = UILoopScroll(self.config.scrollVipBenefit, UIPoolType.VipBenefitDetailView, onCreateItem)
end

function UIVipNewView:InitVipTabs()
	--- @param obj ButtonVipTabView
	local onUpdateItem = function(obj, index)
		local isTabChosen = self.currentVipPreview ==  ResourceMgr.GetVipConfig():GetBenefits(index + 1).vipLevel
		obj:SetButtonState(isTabChosen)
	end
	--- @param obj ButtonVipTabView
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		local vipLevel = ResourceMgr.GetVipConfig():GetBenefits(dataIndex).vipLevel
		obj:SetTextTab(vipLevel)
		obj:AddListener(function()
			self:SelectTabVip(dataIndex)
		end)
		onUpdateItem(obj, index)
	end
	--- @type UILoopScroll
	self.scrollVipTab = UILoopScroll(self.config.scrollVipTab, UIPoolType.ButtonVipTabView, onCreateItem, onUpdateItem)
	self.scrollVipTab:Resize(ResourceMgr.GetVipConfig():GetCount() - 1)
end

function UIVipNewView:SelectTabVip(vipLevel)
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	self.currentVipPreview = vipLevel;
	self.scrollVipTab:RefreshCells(ResourceMgr.GetVipConfig():GetCount() - 1)
	self:ViewVip(vipLevel)
	self:ShowVipProcess(vipLevel)
end