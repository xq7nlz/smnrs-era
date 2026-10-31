---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiVip.UIVipConfig"

--- @class UIVipView : UIBaseView
UIVipView = Class(UIVipView, UIBaseView)

--- @return void
--- @param model UIVipModel
function UIVipView:Ctor(model)
	--- @type UIVipConfig
	self.config = nil
	---@type List --ItemView
	self.listDescription1 = List()
	---@type List --ItemView
	self.listDescription2 = List()
	---@type number
	self.currentVipPreview = 1
	---@type UnityEngine_UI_VerticalLayoutGroup
	self.currentContent1 = nil
	---@type UnityEngine_UI_VerticalLayoutGroup
	self.currentContent2 = nil
	--- @type number
	self.delta = 1500
	--- @type number
	self.timeMove = 0.4
	--- @type number
	self.moving = false
	---@type UIBarPercentView
	self.process = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIVipModel
	self.model = model
end

--- @return void
function UIVipView:OnReadyCreate()
	---@type UIVipConfig
	self.config = UIBaseConfig(self.uiTransform)
	---@type UIBarPercentView
	self.process = UIBarPercentView(self.config.process)
	self.config.bg.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.config.iconArrowLeft.onClick:AddListener(function ()
		self:BackVip()
	end)

	self.config.iconArrowRight.onClick:AddListener(function ()
		self:NextVip()
	end)
end

--- @return void
function UIVipView:OnReadyShow()
	self.currentVipPreview = math.max(zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel, 1)
	self:ViewVip(self.currentVipPreview)
	self.currentContent1.transform.localPosition = U_Vector3.zero
	self.config.scroll.content = self.currentContent1.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform)
	self:CheckVip()
	self:ShowVipProcess()
end

--- @return void
function UIVipView:InitLocalization()
	self.config.textVipFull.text = LanguageUtils.LocalizeCommon("vip_full")
	self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIVipView:Hide()
	UIBaseView.Hide(self)
	---@param v VipDescriptionView
	for i, v in pairs(self.listDescription1:GetItems()) do
		v:ReturnPool()
	end
	self.listDescription1:Clear()
	---@param v VipDescriptionView
	for i, v in pairs(self.listDescription2:GetItems()) do
		v:ReturnPool()
	end
	self.listDescription2:Clear()
end

--- @return void
function UIVipView:BackVip()
	if not self.moving then
		self.moving = true
		self.currentVipPreview = self.currentVipPreview - 1
		self:ViewVip(self.currentVipPreview)
		self.currentContent1.transform.localPosition = U_Vector3(-self.delta, 0, 0)
		DOTweenUtils.DOLocalMoveX(self.currentContent1.transform, 0, self.timeMove, U_Ease.OutBack, function ()
			self.moving = false
			self.config.scroll.content = self.currentContent1.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform)
		end)
		DOTweenUtils.DOLocalMoveX(self.currentContent2.transform, self.delta, self.timeMove, U_Ease.OutBack)
		self:CheckVip()
	end
end

--- @return void
function UIVipView:NextVip()
	if not self.moving then
		self.moving = true
		self.currentVipPreview = self.currentVipPreview + 1
		self:ViewVip(self.currentVipPreview)
		self.currentContent1.transform.localPosition = U_Vector3(self.delta, 0, 0)
		DOTweenUtils.DOLocalMoveX(self.currentContent1.transform, 0, self.timeMove, U_Ease.OutBack, function ()
			self.moving = false
			self.config.scroll.content = self.currentContent1.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform)
		end)
		DOTweenUtils.DOLocalMoveX(self.currentContent2.transform, -self.delta, self.timeMove, U_Ease.OutBack)
		self:CheckVip()
	end
end

--- @return void
function UIVipView:CheckVip()
	self.config.iconArrowLeft.gameObject:SetActive(self.currentVipPreview > 1)
	self.config.iconArrowRight.gameObject:SetActive(self.currentVipPreview < ResourceMgr.GetVipConfig().maxVip)
end

--- @return void
function UIVipView:ShowVipProcess()
	---@type number
	local currentVip = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
	local vipPoint = InventoryUtils.GetMoney(MoneyType.VIP_POINT)
	self.config.iconVipCurrent.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, currentVip)
	self.config.iconVipCurrent:SetNativeSize()

	local nextVipLevel = math.max(ResourceMgr.GetVipConfig():GetVipLevel(vipPoint) + 1,currentVip + 1)
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
		self.process:SetText(LanguageUtils.LocalizeCommon("max"))
	end
end

--- @return UnityEngine_RectTransform, List
--- @param vipLevel number
function UIVipView:ViewVip(vipLevel)
	---@type List
	local listDescription
	if vipLevel % 2 == 0 then
		self.currentContent1 = self.config.content
		self.currentContent2 = self.config.content2
		listDescription = self.listDescription1
	else
		self.currentContent1 = self.config.content2
		self.currentContent2 = self.config.content
		listDescription = self.listDescription2
	end

	self.config.textVipPreview.text = LanguageUtils.LocalizeVip("vip_" .. vipLevel)
	self.config.iconVipPreview.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, vipLevel)
	self.config.iconVipPreview:SetNativeSize()

	---@param v VipDescriptionView
	for i, v in pairs(listDescription:GetItems()) do
		v:ReturnPool()
	end
	listDescription:Clear()
	---@type List
	local vipRewardInstant = ResourceMgr.GetVipRewardInstant():GetListRewardByVipLevel(vipLevel)
	---@type List
	local vipRewardDaily = ResourceMgr.GetVipRewardDaily():GetListRewardByVipLevel(vipLevel)
	---@type VipData
	local vipConfig = ResourceMgr.GetVipConfig():GetBenefits(vipLevel)
	---@type VipData
	local vipConfigLast = ResourceMgr.GetVipConfig():GetBenefits(vipLevel - 1)

	if vipRewardInstant ~= nil and vipRewardInstant:Count() > 0 then
		---@type VipDescriptionView
		local description = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipDescriptionView, self.currentContent1.transform)
		description:SetData(LanguageUtils.LocalizeVip("vip_instant"), vipRewardInstant)
		listDescription:Add(description)
	end

	if vipRewardDaily ~= nil and vipRewardDaily:Count() > 0 and vipRewardDaily.subscriptionPackId ~= 3 then
		-- TODO fake an daily reward manh hero tren ui
		---@type VipDescriptionView
		local description = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipDescriptionView, self.currentContent1.transform)
		description:SetData(LanguageUtils.LocalizeVip("vip_daily"), vipRewardDaily)
		listDescription:Add(description)
	end

	local addProperty = function (key, property)
		---@type VipDescriptionView
		local description = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipDescriptionView, self.currentContent1.transform)
		description:SetData(string.format(LanguageUtils.LocalizeVip(key), UIUtils.SetColorString(UIUtils.color2, property)))
		listDescription:Add(description)
		--if MathUtils.IsNumber(property) and property > 0 then
		--	description:SetData(string.format(LanguageUtils.LocalizeVip(key), UIUtils.SetColorString(UIUtils.color2, property)))
		--	listDescription:Add(description)
		--else
		--end
	end

	local addPropertyUnlock = function (key, property, lastProperty)
		if property == true and lastProperty == false then
			---@type VipDescriptionView
			local description = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipDescriptionView, self.currentContent1.transform)
			description:SetData(LanguageUtils.LocalizeVip(key))
			listDescription:Add(description)
		end
	end

	if vipConfig == nil then
		return
	end
	if vipConfig.campaignBonusIdleTimeMax > 0 then
		addProperty("campaign_bonus_idle_time_max", "+" .. vipConfig.campaignBonusIdleTimeMax / TimeUtils.SecondAHour .. "h")
	end
	if vipConfig.campaignBonusGold > 0 then
		addProperty("campaign_bonus_gold", vipConfig.campaignBonusGold * 100 .. "%")
	end
	if vipConfig.campaignBonusMagicPotion > 0 then
		addProperty("campaign_bonus_magic_potion", vipConfig.campaignBonusMagicPotion * 100 .. "%")
	end
	if vipConfig.tavernBonusQuest > 0 then
		addProperty("tavern_bonus_quest", "+" .. vipConfig.tavernBonusQuest)
	end
	if vipConfig.raidBonusTurnBuy > 0 then
		addProperty("raid_bonus_turn_buy", "+" .. vipConfig.raidBonusTurnBuy)
	end
	addPropertyUnlock("casino_unlock_multiple_spin", vipConfig.casinoUnlockMultipleSpin, vipConfigLast.casinoUnlockMultipleSpin)
	addPropertyUnlock("casino_unlock_premium_spin", vipConfig.casinoUnlockPremiumSpin, vipConfigLast.casinoUnlockPremiumSpin)
	if vipConfig.casinoBonusTurnBuyBasicChip > 0 then
		addProperty("casino_bonus_turn_buy_basic_chip", "+" .. vipConfig.casinoBonusTurnBuyBasicChip)
	end
	addPropertyUnlock("battle_unlock_speed_up", vipConfig.battleUnlockSpeedUp, vipConfigLast.battleUnlockSpeedUp)
	addPropertyUnlock("battle_unlock_skip", vipConfig.battleUnlockSkip, vipConfigLast.battleUnlockSkip)
	addPropertyUnlock("summon_unlock_accumulate", vipConfig.summonUnlockAccumulate, vipConfigLast.summonUnlockAccumulate)
	if vipConfig.arenaBonusTicketBuy > 0 then
		addProperty("arena_bonus_ticket_buy", "+" .. vipConfig.arenaBonusTicketBuy)
	end
	if vipConfig.campaignBonusQuickBattleBuyTurn > 0 then
		addProperty("campaign_bonus_quick_battle_buy_turn", "+" .. vipConfig.campaignBonusQuickBattleBuyTurn)
	end

	Coroutine.start(function ()
		---@type VipDescriptionView
		local vipUnlockReward = listDescription:Get(1)
		vipUnlockReward.config.itemVipContent.enabled = false
		vipUnlockReward.config.itemVipContent.enabled = true
		coroutine.waitforendofframe()
		self.currentContent1.enabled = false
		self.currentContent1.enabled = true
		coroutine.waitforendofframe()
		self.currentContent1.enabled = false
		self.currentContent1.enabled = true
	end)
end