require "lua.client.scene.ui.home.uiEventZodiac.layout.UIEventZodiacLayout"
--- @class UIEventZodiacExchangeLayout : UIEventZodiacLayout
UIEventZodiacExchangeLayout = Class(UIEventZodiacExchangeLayout, UIEventZodiacLayout)

--- @param view UIEventZodiacView
--- @param eventZodiacTab EventZodiacTab
--- @param anchor UnityEngine_RectTransform
function UIEventZodiacExchangeLayout:Ctor(view, eventZodiacTab, anchor)
	--- @type UIEventZodiacView
	self.view = view
	--- @type EventZodiacTab
	self.eventZodiacTab = eventZodiacTab
	--- @type UnityEngine_RectTransform
	self.anchor = anchor
	--- @type UIEventZodiacExchangeConfig
	self.layoutConfig = nil
	--- @type EventZodiacModel
	self.eventModel = nil
	--- @type EventZodiacConfig
	self.eventConfig = nil
	self.eventTimeType = EventTimeType.EVENT_ZODIAC
	UIEventLayout.Ctor(self, view, self.eventTimeType)
	self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventZodiacExchangeLayout:InitLayoutConfig(objectView)
	local inst = PrefabLoadUtils.Instantiate("zodiac_exchange_layout", self.anchor)
	UIEventZodiacLayout.InitLayoutConfig(self, inst)
	self:InitScroll()
end

function UIEventZodiacExchangeLayout:SetUpLayout()
	UIEventZodiacLayout.SetUpLayout(self)
	self:InitButtonAddListener()
end

function UIEventZodiacExchangeLayout:InitLocalization()
	self.layoutConfig.headerText.text = LanguageUtils.LocalizeCommon("zodiac_exchange")
	self.layoutConfig.collectButtonText.text = LanguageUtils.LocalizeCommon("collect")
end

function UIEventZodiacExchangeLayout:InitButtonAddListener()
	self.layoutConfig.backButton.onClick:RemoveAllListeners()
	self.layoutConfig.backButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
		self:CloseLayout()
	end)
	self.layoutConfig.collectPearlButton.onClick:RemoveAllListeners()
	self.layoutConfig.collectPearlButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
		self:CollectPearl()
	end)
end

function UIEventZodiacExchangeLayout:CollectPearl()
	if self.eventModel.numberRewardBonusExchange == 0 then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_thing_to_claim"))
		return
	end
	local onReceived = function(result)
		--- @type List
		local listReward = List()
		--- @type List
		local listIconData = List()
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			local size = buffer:GetByte()
			for i = 1, size do
				listReward:Add(RewardInBound.CreateByBuffer(buffer))
			end
		end
		local onSuccess = function()
			for i = 1, listReward:Count() do
				listIconData:Add(listReward:Get(i):GetIconData())
			end
			self.eventModel.numberRewardBonusExchange = 0
			PopupUtils.ClaimAndShowRewardList(listReward)
			self:UpdateMoneyItem()
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end
	NetworkUtils.Request(OpCode.EVENT_ZODIAC_COLLECT_REWARD_CLAIM,nil, onReceived)

end

function UIEventZodiacExchangeLayout:OnShow(view)
	UIEventZodiacLayout.OnShow(self)
	self:InitLocalization()
	self.uiScroll:Resize(self.eventConfig:GetExchangeRewardConfig():Count())
	--- @type MoneyBarView
	self.starMoney = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.starAnchor)
	--- @type MoneyBarView
	self.pearlMoney = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.pearlAnchor)
	self:UpdateMoneyItem()
end

function UIEventZodiacExchangeLayout:UpdateMoneyItem()
	self.starMoney:SetIconData(MoneyType.STAR_POINT)
	self.pearlMoney:SetIconData(MoneyType.SUPER_PEARL)
	self.layoutConfig.collectPearlText.text = LanguageUtils.LocalizeCommon("collect_pearl_desc")..
			" ".. UIUtils.SetColorString(UIUtils.green_light,self.eventModel.numberRewardBonusExchange)
end

function UIEventZodiacExchangeLayout:InitScroll()
	--- @param obj ZodiacExchangePoolView
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type Dictionary
		local exchangeRewardDict = self.eventConfig:GetExchangeRewardConfig()
		local listExchangeReward = exchangeRewardDict:Get(dataIndex)
		obj:SetData(dataIndex, listExchangeReward, function(stageId, id, price, item)
			self:OnClickOpen(stageId, id, price, item)
		end, self.eventModel)
	end
	self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ZodiacExchangePoolView, onCreateItem, onCreateItem)
end

--- @param item ZodiacExchangeItemView
function UIEventZodiacExchangeLayout:OnClickOpen(stageId, id, price, item)
	if not self.eventModel.exchangeStateMapServer:IsContainKey(id) then
		local content = LanguageUtils.LocalizeCommon("need_clear_previous_stage")
		SmartPoolUtils.ShowShortNotification(content)
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		return
	end
	if self.eventModel:GetNumberExchange(id) - self.eventConfig:GetExchangeRewardConfig():Get(stageId):Get(id - (stageId - 1) * 3).limit >= 0 then
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		SmartPoolUtils.LogicCodeNotification(LogicCode.ZODIAC_EXCHANGE_REACHED_LIMIT)
		return
	end
	if InventoryUtils.GetMoney(MoneyType.STAR_POINT) < price then
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		local data = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.STAR_POINT, price)
		return InventoryUtils.IsEnoughSingleResourceRequirement(data, true)
	end
	zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
	local onReceived = function(result)
		--- @type List
		local listReward = List()
		--- @type List
		local listIconData = List()
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			local size = buffer:GetByte()
			for i = 1, size do
				listReward:Add(RewardInBound.CreateByBuffer(buffer))
			end
		end
		local onSuccess = function()
			for i = 1, listReward:Count() do
				listIconData:Add(listReward:Get(i):GetIconData())
			end

			PopupUtils.ClaimAndShowRewardList(listReward)

			InventoryUtils.Sub(ResourceType.Money, MoneyType.STAR_POINT, price)
			local bonus = self.eventConfig:GetBonusRewardById(id).number
			self.eventModel.numberRewardBonusExchange =self.eventModel.numberRewardBonusExchange + bonus

			self:UpdateMoneyItem()
			self.view:UpdateNotificationByTab(EventZodiacTab.EXCHANGE)
			for i = 1, 3 * (stageId + 1) do
				if not self.eventModel.exchangeStateMapServer:IsContainKey(i) then
					self.eventModel.exchangeStateMapServer:Add(i, true)
				end
				self.eventModel.exchangeStateMapServer[i] = true
			end

			self.eventModel:AddNumberExchange(id)

			self.uiScroll:RefreshCells(self.eventConfig:GetExchangeRewardConfig():Count())
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end

	PopupUtils.ShowPopupNotificationUseResource(MoneyType.STAR_POINT, price, function()
		NetworkUtils.Request(OpCode.EVENT_ZODIAC_EXCHANGE,
				UnknownOutBound.CreateInstance(PutMethod.Int, id, PutMethod.Int, 1),
				onReceived)
	end)
end

function UIEventZodiacExchangeLayout:OnHide()
	UIEventZodiacLayout.OnHide(self)
	self.uiScroll:Hide()
	self.starMoney:ReturnPool()
	self.pearlMoney:ReturnPool()
end
