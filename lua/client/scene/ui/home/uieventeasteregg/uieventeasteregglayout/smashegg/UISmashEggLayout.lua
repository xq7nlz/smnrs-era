--- @class UISmashEggLayout : UIEventEasterEggLayout
UISmashEggLayout = Class(UISmashEggLayout, UIEventEasterEggLayout)

--- @param view UIEventXmasView
--- @param tab XmasTab
--- @param anchor UnityEngine_RectTransform
function UISmashEggLayout:Ctor(view, tab, anchor)
	--- @type UISmashEggConfig
	self.layoutConfig = nil
	--- @type List
	self.listMoney = nil
	--- @type UIButtonSmashEggConfig
	self.buttonEgg1 = nil

	UIEventEasterEggLayout.Ctor(self, view, tab, anchor)
end

function UISmashEggLayout:InitLayoutConfig()
	local inst = PrefabLoadUtils.Instantiate("smash_egg", self.anchor)
	UIEventEasterEggLayout.InitLayoutConfig(self, inst)

	--- @type UIButtonSmashEggConfig
	self.buttonEgg1 = UIBaseConfig(self.layoutConfig.buttonContent:GetChild(0))
	--- @type UIButtonSmashEggConfig
	self.buttonEgg2 = UIBaseConfig(self.layoutConfig.buttonContent:GetChild(1))
	--- @type UIButtonSmashEggConfig
	self.buttonEgg3 = UIBaseConfig(self.layoutConfig.buttonContent:GetChild(2))

	self:InitButtonListener()
	self:InitLocalization()
end

function UISmashEggLayout:InitLocalization()
	UIEventEasterEggLayout.InitLocalization(self)
	self.layoutConfig.textContent.text = LanguageUtils.LocalizeCommon("smash_egg_desc")
	local smash = LanguageUtils.LocalizeCommon("smash_egg")
	self.buttonEgg1.textButton.text = smash
	self.buttonEgg2.textButton.text = smash
	self.buttonEgg3.textButton.text = smash
	--self.layoutConfig.textEggCombine.text = LanguageUtils.LocalizeCommon("egg_combine")
end

function UISmashEggLayout:InitButtonListener()
	self.buttonEgg1.buttonGreen.onClick:AddListener(function()
		self:OnClickSmash(MoneyType.EVENT_EASTER_WOOD_HAMMER, 1)
	end)
	self.buttonEgg2.buttonGreen.onClick:AddListener(function()
		self:OnClickSmash(MoneyType.EVENT_EASTER_YELLOW_HAMMER, 2)
	end)
	self.buttonEgg3.buttonGreen.onClick:AddListener(function()
		self:OnClickSmash(MoneyType.EVENT_EASTER_RAINBOW_HAMMER, 3)
	end)
	--self.layoutConfig.eggCombineButton.onClick:AddListener(function()
	--	self:OnClickEggCombine()
	--end)
	self.layoutConfig.silverEggButton.onClick:AddListener(function()
		self:OnClickEggSilver()
	end)
	self.layoutConfig.goldenEggButton.onClick:AddListener(function()
		self:OnClickEggYellow()
	end)
	self.layoutConfig.rainbowEggButton.onClick:AddListener(function()
		self:OnClickEggRainbow()
	end)
end

function UISmashEggLayout:OnShow()
	UIEventEasterEggLayout.OnShow(self)
	if self.listMoney == nil then
		self.listMoney = List()
		--- @type MoneyBarView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.currencyBar)
		iconView:SetIconData(MoneyType.EVENT_EASTER_WOOD_HAMMER, true)
		self.listMoney:Add(iconView)
		iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.currencyBar)
		iconView:SetIconData(MoneyType.EVENT_EASTER_YELLOW_HAMMER, true)
		self.listMoney:Add(iconView)
		iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.currencyBar)
		iconView:SetIconData(MoneyType.EVENT_EASTER_RAINBOW_HAMMER, true)
		self.listMoney:Add(iconView)
	end
	self:UpdateUI()
end

function UISmashEggLayout:UpdateUI()
	self:UpdateUIButtonEgg(self.buttonEgg1, 1, MoneyType.EVENT_EASTER_SILVER_EGG)
	self:UpdateUIButtonEgg(self.buttonEgg2, 2, MoneyType.EVENT_EASTER_YELLOW_EGG)
	self:UpdateUIButtonEgg(self.buttonEgg3, 3, MoneyType.EVENT_EASTER_RAINBOW_EGG)
end

---@param buttonEgg UIButtonSmashEggConfig
function UISmashEggLayout:UpdateUIButtonEgg(buttonEgg, index, moneyType)
	-----@type BreakEggPrice
	--local breakEggPrice = self.eventConfig:GetBreakEggPrice(index)
	--buttonEgg.iconCurrency.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyType)
	buttonEgg.textNumber.text = LanguageUtils.LocalizeMoneyType(moneyType)
	--buttonEgg.iconCurrency:SetNativeSize()
	--if (breakEggPrice.gem ~= nil and breakEggPrice.gem > 0) or (breakEggPrice.moneyValue ~= nil and breakEggPrice.moneyValue > 0) then
	--    buttonEgg.textNumber.gameObject:SetActive(true)
	--
	--end
end

function UISmashEggLayout:OnClickEggCombine()
	local data = {}
	data.callbackClose = function()
		PopupMgr.HidePopup(UIPopupName.UIEggCombine)
		self:UpdateUI()
	end
	PopupMgr.ShowPopup(UIPopupName.UIEggCombine, data)
end

function UISmashEggLayout:OnClickEggSilver()
	local data = {}
	--- @type List
	data.listRewardIconData = self.eventConfig:GetListRewardEgg(EggType.Silver)
	data.uiPoolType = UIPoolType.RateView
	PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

function UISmashEggLayout:OnClickEggYellow()
	local data = {}
	--- @type List
	data.listRewardIconData = self.eventConfig:GetListRewardEgg(EggType.Yellow)
	data.uiPoolType = UIPoolType.RateView
	PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

function UISmashEggLayout:OnClickEggRainbow()
	local data = {}
	--- @type List
	data.listRewardIconData = self.eventConfig:GetListRewardEgg(EggType.Rainbow)
	data.uiPoolType = UIPoolType.RateView
	PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

---@param egg MoneyType
function UISmashEggLayout:OnClickSmash(egg, index)
	---@type BreakEggPrice
	local breakEggPrice = self.eventConfig:GetBreakEggPrice(index)
	local data = {}
	if breakEggPrice.moneyValue ~= nil and InventoryUtils.Get(ResourceType.Money, breakEggPrice.moneyType) >= breakEggPrice.moneyValue then
		data.moneyType = breakEggPrice.moneyType
		data.maxInput = math.min(InventoryUtils.GetMoney(egg),
				math.floor(InventoryUtils.GetMoney(breakEggPrice.moneyType) / breakEggPrice.moneyValue))
		data.step = breakEggPrice.moneyValue
		data.item = ItemIconData.CreateInstance(ResourceType.Money, egg)
	end

	if data.maxInput ~= nil then
		data.title = LanguageUtils.LocalizeMoneyType(egg)
		data.number = 1
		data.minInput = 1
		data.callbackSmash = function(number)
			local listReward = nil
			local onBufferReading = function(buffer)
				listReward = NetworkUtils.GetRewardInBoundList(buffer)
			end
			local onSuccess = function()
				Coroutine.start(function()
					self:PlaySmashAnim(egg)
					coroutine.waitforseconds(1.3)
					self:PlayIdleAnim(egg)
					PopupUtils.ClaimAndShowRewardList(listReward)
					InventoryUtils.Sub(ResourceType.Money, egg, number)
					self:UpdateUI()
					self.view:CheckAllNotificationTab()
				end)
			end
			NetworkUtils.RequestAndCallback(OpCode.EVENT_EASTER_EGG_BREAK,
					UnknownOutBound.CreateInstance(PutMethod.Int, number, PutMethod.Int, index),
					onSuccess, onSuccess, onBufferReading)
		end
		PopupMgr.ShowPopup(UIPopupName.UISmashPopup, data)
	else
		InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, breakEggPrice.moneyType, breakEggPrice.moneyValue))
	end
end

function UISmashEggLayout:PlaySmashAnim(egg)
	if egg == MoneyType.EVENT_EASTER_WOOD_HAMMER then
		self.layoutConfig.animSilverEgg.AnimationState:SetAnimation(0, "cracked_egg", false)
	elseif egg == MoneyType.EVENT_EASTER_YELLOW_HAMMER then
		self.layoutConfig.animGoldEgg.AnimationState:SetAnimation(0, "cracked_egg", false)
	elseif egg == MoneyType.EVENT_EASTER_RAINBOW_HAMMER then
		self.layoutConfig.animRainbowEgg.AnimationState:SetAnimation(0, "cracked_egg", false)
	end
end

function UISmashEggLayout:PlayIdleAnim(egg)
	if egg == MoneyType.EVENT_EASTER_WOOD_HAMMER then
		self.layoutConfig.animSilverEgg.AnimationState:SetAnimation(0, "idle", true)
	elseif egg == MoneyType.EVENT_EASTER_YELLOW_HAMMER then
		self.layoutConfig.animGoldEgg.AnimationState:SetAnimation(0, "idle", true)
	elseif egg == MoneyType.EVENT_EASTER_RAINBOW_HAMMER then
		self.layoutConfig.animRainbowEgg.AnimationState:SetAnimation(0, "idle", true)
	end
end

function UISmashEggLayout:OnHide()
	UIEventEasterEggLayout.OnHide(self)
	if self.listMoney ~= nil then
		---@param v MoneyBarView
		for i, v in ipairs(self.listMoney:GetItems()) do
			v:ReturnPool()
		end
		self.listMoney:Clear()
		self.listMoney = nil
	end
end