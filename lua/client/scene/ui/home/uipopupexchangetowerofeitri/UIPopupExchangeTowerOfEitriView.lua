
--- @class UIPopupExchangeTowerOfEitriView : UIBaseView
UIPopupExchangeTowerOfEitriView = Class(UIPopupExchangeTowerOfEitriView, UIBaseView)

--- @param model UIPopupExchangeTowerOfEitriModel
function UIPopupExchangeTowerOfEitriView:Ctor(model)
	--- @type UIPopupExchangeTowerOfEitriConfig
	self.config = nil
	---@type function
	self.callbackExchange = nil
	---@type number
	self.eitriCoinOwn = 0
	---@type number
	self.infinityCoinOwn = 0
	---@type number
	self.eitriCoinUse = 0
	---@type number
	self.infinityCoinUse = 0
	---@type number
	self.itemPrice = 0
	---@type boolean
	self.isUseInfinityCoin = false
	UIBaseView.Ctor(self, model)
	--- @type UIPopupExchangeTowerOfEitriModel
	self.model = model
end

function UIPopupExchangeTowerOfEitriView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtons()
end

function UIPopupExchangeTowerOfEitriView:InitButtons()
	self.config.background.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)

	self.config.buttonYes.onClick:AddListener(function()
		self:OnClickExchange()
	end)

	self.config.buttonNo.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIPopupExchangeTowerOfEitriView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("popup_exchange_tower_of_eitri_title_text")
	self.config.textAsk.text = LanguageUtils.LocalizeCommon("popup_exchange_tower_of_eitri_ask_text")
	self.config.textNo.text = LanguageUtils.LocalizeCommon("no")
	self.config.textYes.text = LanguageUtils.LocalizeCommon("yes")
end

function UIPopupExchangeTowerOfEitriView:OnClickExchange()
	if self.eitriCoinUse + self.infinityCoinUse >= self.itemPrice then
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBackOrClose()
		if self.infinityCoinUse > 0 then
			self.isUseInfinityCoin = true
		else
			self.isUseInfinityCoin = false
		end

		if self.callbackExchange ~= nil then
			self.callbackExchange(self.eitriCoinUse,self.infinityCoinUse, self.isUseInfinityCoin)
		end
	else
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_resource"))
	end
end

function UIPopupExchangeTowerOfEitriView:Init(result)
	self.itemPrice = result.itemPrice
	--- @type RewardInBound
	self.itemData = result.itemData
	self.callbackExchange = result.callbackExchange
	self.eitriCoinOwn = InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_COIN)
	self.infinityCoinOwn = InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_INFINITY_COIN)

	self:UpdateUI()
end

function UIPopupExchangeTowerOfEitriView:UpdateUI()
	self.config.priceTypeEitri.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.EVENT_DRAGON_TOWER_COIN)
	self.config.priceTypeInfinity.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.EVENT_DRAGON_TOWER_INFINITY_COIN)
	self.config.priceTypeInfinity:SetNativeSize()
	self.config.priceTypeEitri:SetNativeSize()

	if self.eitriCoinOwn < self.itemPrice then
		self.eitriCoinUse = self.eitriCoinOwn
		self.infinityCoinUse = self.itemPrice - self.eitriCoinUse
	else
		self.eitriCoinUse = self.itemPrice
		self.infinityCoinUse = 0
	end

	self.config.priceEitriText.text = self.eitriCoinUse
	self.config.priceInfinityText.text = self.infinityCoinUse
end

--- @param data {callbackClose : function}
function UIPopupExchangeTowerOfEitriView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:Init(data)
end
