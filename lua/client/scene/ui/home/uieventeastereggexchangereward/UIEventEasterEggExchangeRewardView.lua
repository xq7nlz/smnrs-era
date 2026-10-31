require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.Dice.EasterEggExchangeReward.EasterEggExchangeRewardOutbound"
--- @class UIEventEasterEggExchangeRewardView : UIBaseView
UIEventEasterEggExchangeRewardView = Class(UIEventEasterEggExchangeRewardView, UIBaseView)

--- @param model UIEventEasterEggExchangeRewardModel
function UIEventEasterEggExchangeRewardView:Ctor(model)
	--- @type UIEasterEggExchangeConfig
	self.config = nil
	--- @type UILoopScroll
	self.scroll = nil
	--- @type function
	self.callback = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventEasterEggExchangeRewardModel
	self.model = model
	--- @type List
	self.listItemExchanges = List()


end

function UIEventEasterEggExchangeRewardView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtons()
	self:InitScroll()
	self:InitData()
end

function UIEventEasterEggExchangeRewardView:InitData()

end

function UIEventEasterEggExchangeRewardView:InitButtons()
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)

	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIEventEasterEggExchangeRewardView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	self:OnReadyHide()
end
function UIEventEasterEggExchangeRewardView:InitScroll()
	--- @param obj EasterEggExchangeItemView
	local onCreateItem = function(obj, index)
		--- @type EasterEggExchangeRewardConfig
		local reward = self.listExchangeReward:Get(index + 1)
		obj:SetIconData(reward)
		obj:AddListener(function(id)
			self:ExchangeReward(id)
		end)
		self.listItemExchanges:Add(obj)
	end
	self.scroll = UILoopScroll(self.config.scroll, UIPoolType.EasterEggExchangeItemView, onCreateItem)
end

function UIEventEasterEggExchangeRewardView:ExchangeReward(id)
	local price = self.listExchangeReward:Get(id).price
	local reward = RewardInBound.CreateBySingleParam(ResourceType.Money,
			MoneyType.EVENT_EASTER_POINT,
			price)
	local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(reward,true)

	local onReceived = function(result)
		--- @type List
		local rewards
		--- @type List
		local listReward
		local onBufferReading = function(buffer)
			rewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
			listReward = List()
			for i = 1, rewards:Count() do
				listReward:Add(rewards:Get(i):GetIconData())
			end
		end

		local onSuccess = function()
			InventoryUtils.AddListItemIconData(listReward)
			PopupUtils.ShowRewardList(listReward)
			InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_EASTER_POINT,
					price)
			self.callback()
			for i = 1, self.listItemExchanges:Count() do
				self.listItemExchanges:Get(i):UpdateTextPrice()
			end
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end

	if canRoll then
		NetworkUtils.Request(OpCode.EVENT_EASTER_POINT_REWARD, UnknownOutBound.CreateInstance(PutMethod.Int, id), onReceived)
	end
end

function UIEventEasterEggExchangeRewardView:InitLocalization()
	self.config.textTapToClose.text = LanguageUtils.LocalizeCommon("tap_to_close")
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("easter_egg_exchange_reward")

end

--- @param data { listExchangeReward , callbackExchange}
function UIEventEasterEggExchangeRewardView:OnReadyShow(data)
	--- @type EventEasterEggModel
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
	self.listExchangeReward = data.listExchangeReward
	self.callback = data.callbackExchange
	self:InitLocalization()
	self.scroll:Resize(self.listExchangeReward:Count())
	---@type MoneyBarView
	self.moneyBar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.moneyBar)
	self.moneyBar:SetIconData(MoneyType.EVENT_EASTER_POINT)
end

function UIEventEasterEggExchangeRewardView:Hide()
	UIBaseView.Hide(self)
	self.listItemExchanges:Clear()
	self.scroll:Hide()
	self.moneyBar:ReturnPool()
end

