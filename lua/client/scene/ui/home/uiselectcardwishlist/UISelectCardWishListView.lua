
--- @class UISelectCardWishListView : UIBaseView
UISelectCardWishListView = Class(UISelectCardWishListView, UIBaseView)

--- @return void
--- @param model UISelectCardWishListModel
function UISelectCardWishListView:Ctor(model)
	---@type List
	self.listItemData = List()
	---@type List
	self.listRoundCard = List()
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UISelectCardWishListModel
	self.model = model
end

--- @return void
function UISelectCardWishListView:OnReadyCreate()
	--- @type UISelectCardWishListConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.selectButton.onClick:AddListener(function()
		self:OnClickSelect()
	end)
end

function UISelectCardWishListView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_card_wish_list")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end


--- @return void
function UISelectCardWishListView:OnReadyShow(result)
	---@type ValentineOpenCardData
	self.valentineOpenCardData = result.valentineOpenCardData
	---@type EventValentineOpenCardConfig
	self.eventValentineOpenCardConfig = result.eventValentineOpenCardConfig
	self.callbackSelect = result.callbackSelect
	self.cardSelect = self.valentineOpenCardData.wishCardSelected

	self:ReturnListItem()
	for i, v in ipairs(self.eventValentineOpenCardConfig.listRound:GetItems()) do
		---@type RoundCardWishItemView
		local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RoundCardWishItemView, self.config.content)
		if v == 1 then
			itemView.config.textRound.transform.parent.gameObject:SetActive(false)
		else
			itemView.config.textRound.transform.parent.gameObject:SetActive(true)
			if v > self.valentineOpenCardData.reachedRound + 1 then
				itemView.config.textRound.text = string.format(LanguageUtils.LocalizeCommon("unlock_round") , v)
			else
				itemView.config.textRound.text = string.format(LanguageUtils.LocalizeCommon("select_round") , v)
			end
		end
		---@type List
		local list = self.eventValentineOpenCardConfig:GetListCardWishByRound(v)
		---@param v EventValentineOpenCardWish
		for i, v in ipairs(list:GetItems()) do
			---@type RootIconView
			local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, itemView.config.content)
			itemView:SetIconData(v.reward:GetIconData())
			itemView:AddListener(function ()
				self:OnSelect(itemView, v)
			end)
			if self.cardSelect == v.id then
				self.currentItemSelect = itemView
				itemView:ActiveMaskSelect(true)
			elseif self.valentineOpenCardData.wishCardHistories:IsContainValue(v.id) then
				itemView:ActiveMaskClose(true)
			elseif self.valentineOpenCardData.reachedRound + 1 < v.round then
				itemView:ActiveMaskLock(true)
			end
			self.listItemData:Add(itemView)
		end
		self.listRoundCard:Add(itemView)
		Coroutine.start(function ()
			itemView.config.contentSize.enabled = false
			itemView.config.contentSize.enabled = true
			coroutine.waitforendofframe()
			itemView.config.contentSize.enabled = false
			itemView.config.contentSize.enabled = true
		end)
	end
	Coroutine.start(function ()
		self.config.contentSize.enabled = false
		self.config.contentSize.enabled = true
		coroutine.waitforendofframe()
		self.config.contentSize.enabled = false
		self.config.contentSize.enabled = true
		coroutine.waitforendofframe()
		self.config.contentSize.enabled = false
		self.config.contentSize.enabled = true
	end)
end

--- @return void
--- @param eventValentineOpenCardWish EventValentineOpenCardWish
function UISelectCardWishListView:OnSelect(item, eventValentineOpenCardWish)
	if eventValentineOpenCardWish.round > self.valentineOpenCardData.reachedRound + 1 then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("lock"))
	elseif self.valentineOpenCardData.wishCardHistories:IsContainValue(eventValentineOpenCardWish.id) then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("item_not_select"))
	else
		if self.currentItemSelect ~= nil then
			self.currentItemSelect:ActiveMaskSelect(false)
		end
		self.currentItemSelect = item
		self.currentItemSelect:ActiveMaskSelect(true)
		self.cardSelect = eventValentineOpenCardWish.id
	end
end

--- @return void
function UISelectCardWishListView:OnClickSelect()
	if self.valentineOpenCardData.wishCardSelected ~= self.cardSelect then
		local onReceived = function(result)
			local onSuccess = function()
				if self.valentineOpenCardData.wishCardSelected <= 0 then
					self.valentineOpenCardData.cardPositionOpenMap:Clear()
				end
				self.valentineOpenCardData.wishCardSelected = self.cardSelect
				self:OnClickBackOrClose()
				if self.callbackSelect ~= nil then
					self.callbackSelect(self.cardSelect)
				end
			end
			local onFailed = function(logicCode)
				SmartPoolUtils.LogicCodeNotification(logicCode)
			end
			NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
		end
		NetworkUtils.Request(OpCode.EVENT_VALENTINE_WISH_CARD_SELECT, UnknownOutBound.CreateInstance(PutMethod.Int, self.cardSelect), onReceived)
	else
		self:OnClickBackOrClose()
	end
end

--- @return void
function UISelectCardWishListView:ReturnListItem()
	if self.listRoundCard ~= nil then
		---@param v IconView
		for i, v in ipairs(self.listRoundCard:GetItems()) do
			v:ReturnPool()
		end
		self.listRoundCard:Clear()
	end
	if self.listItemData ~= nil then
		---@param v IconView
		for i, v in ipairs(self.listItemData:GetItems()) do
			v:ReturnPool()
		end
		self.listItemData:Clear()
	end
end

function UISelectCardWishListView:Hide()
	UIBaseView.Hide(self)
	self:ReturnListItem()
end