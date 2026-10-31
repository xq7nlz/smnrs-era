---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildQuestDonate.UIGuildQuestDonateConfig"

--- @class UIGuildQuestDonateView : UIBaseView
UIGuildQuestDonateView = Class(UIGuildQuestDonateView, UIBaseView)

--- @return void
--- @param model UIGuildQuestDonateModel
function UIGuildQuestDonateView:Ctor(model)
	---@type MoneyType
	self.moneyType = nil
	---@type number
	self.currentDonate = nil
	---@type function
	self.callbackDonate = nil
	---@type InputSliderView
	self.input = nil
	---@type MoneyBarLocalView
	self.moneyBar = nil
	---@type MoneyIconView
	self.item1 = nil
	---@type MoneyIconView
	self.item2 = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIGuildQuestDonateModel
	self.model = model
end

--- @return void
function UIGuildQuestDonateView:OnReadyCreate()
	--- @type UIGuildQuestDonateConfig
	---@type UIGuildQuestDonateConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.moneyBar = MoneyBarLocalView(self.config.moneyBarInfo)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.donateButton.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickDonate()
	end)
end

--- @return void
function UIGuildQuestDonateView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_donate_title")
	self.config.textCurrencyOwned.text = LanguageUtils.LocalizeCommon("owned")
	self.config.textCurrencyGuildOwned.text = LanguageUtils.LocalizeCommon("guild_owned")
	self.config.textDonate.text = LanguageUtils.LocalizeCommon("donate")
end


function UIGuildQuestDonateView:OnReadyShow(result)
	self:Init(result)
end

--- @return void
function UIGuildQuestDonateView:Init(result)
	self.moneyType = result.moneyType
	self.currentDonate = result.currentDonate
	self.callbackDonate = result.callbackDonate
	self.moneyBar:SetIconData(self.moneyType)
	self.moneyBar:SetText1(1)
	local totalMoney = InventoryUtils.GetMoney(self.moneyType)
	if self.input == nil then
		self.input = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputSliderView, self.config.inputSliderView)
	end
	self.input:SetData(1, 1, totalMoney)
	self.input.onChangeInput = function(value)
		self.moneyBar:SetText1(value)
	end
	if self.item1 == nil then
		self.item1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView , self.config.icon1)
	end
	self.item1:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, self.moneyType, totalMoney))
	if self.item2 == nil then
		self.item2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView , self.config.icon2)
	end
	self.item2:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, self.moneyType, self.currentDonate))
	local moneyLocalize = LanguageUtils.LocalizeMoneyType(self.moneyType)
	self.config.textCurrencyName1.text = moneyLocalize
	self.config.textCurrencyName2.text = moneyLocalize
end

--- @return void
function UIGuildQuestDonateView:Hide()
	UIBaseView.Hide(self)
	if self.input ~= nil then
		self.input:ReturnPool()
		self.input = nil
	end
	if self.item1 ~= nil then
		self.item1:ReturnPool()
		self.item1 = nil
	end
	if self.item2 ~= nil then
		self.item2:ReturnPool()
		self.item2 = nil
	end
end

--- @return void
function UIGuildQuestDonateView:OnClickDonate()
	NetworkUtils.RequestAndCallback(OpCode.EVENT_GUILD_QUEST_DONATE,
			UnknownOutBound.CreateInstance(PutMethod.Short, 1, PutMethod.Short, self.moneyType, PutMethod.Int, self.input.value),
			function ()
				InventoryUtils.Sub(ResourceType.Money, self.moneyType, self.input.value)
				if self.callbackDonate ~= nil then
					self.callbackDonate(self.input.value)
				end
				self:OnClickBackOrClose()
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
			end , SmartPoolUtils.LogicCodeNotification, nil, true, true)

end