--- @class EasterEggExchangeItemView : IconView
EasterEggExchangeItemView = Class(EasterEggExchangeItemView, IconView)

--- @return void
function EasterEggExchangeItemView:Ctor()
	IconView.Ctor(self)
	--- @type List
	self.listItemSlot = List()
	--- @type List
	self.listItem = List()
	--- @type List
	self.listIconItem = List()
	--- @type List
	self.listItemSelect = List()
end

--- @return void
function EasterEggExchangeItemView:SetPrefabName()
	self.prefabName = 'easter_egg_exchange_item'
	self.uiPoolType = UIPoolType.EasterEggExchangeItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function EasterEggExchangeItemView:SetConfig(transform)
	if transform == nil then
		XDebug.Error("EasterEggExchangeItemView => transform is nil")
	end
	---@type EasterEggExchangeItem
	self.config = UIBaseConfig(transform)
end

--- @return void
--- @param easterEggExchangeRewardConfig EasterEggExchangeRewardConfig
function EasterEggExchangeItemView:SetIconData(easterEggExchangeRewardConfig)
	self.listReward = easterEggExchangeRewardConfig._listReward
	self.easterEggExchangeRewardConfig = easterEggExchangeRewardConfig
	self:GetEventModel()
	if self.easterEggExchangeRewardConfig.isSelectionReward then
		self:GetPoolReward()
		self:CreateItemSlot()
		self:CreateItemSelect()
	end
	self:UpdateTextPrice()
	self.config.exchangeText.text = LanguageUtils.LocalizeCommon("exchange")
	self:CreateItemDefault()
end

--- @return void
--- @param easterEggExchangeRewardConfig EasterEggExchangeRewardConfig
function EasterEggExchangeItemView:UpdateTextPrice()
	local value = InventoryUtils.Get(ResourceType.Money, self.easterEggExchangeRewardConfig.type) - self.easterEggExchangeRewardConfig.price
	if value < 0 then
		self.config.textPrice.text = UIUtils.SetColorString(UIUtils.red_light,self.easterEggExchangeRewardConfig.price)
	else
		self.config.textPrice.text = self.easterEggExchangeRewardConfig.price
	end
end

function EasterEggExchangeItemView:GetPoolReward()
	self.poolReward = List()
	local rewardSelectionList = self.eventModel:GetPoolReward(self.easterEggExchangeRewardConfig.id).rewardSelectionList
	for i = 1, rewardSelectionList:Count() do
		self.poolReward:Add(rewardSelectionList:Get(i).rewardInBound)
	end
end

function EasterEggExchangeItemView:GetEventModel()
	--- @type EventEasterEggModel
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
end
--- @return void
---@param func function
function EasterEggExchangeItemView:AddListener(func)
	self:_RemoveListener()
	self.config.exchangeButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		func(self.easterEggExchangeRewardConfig.id)
	end)
end

--- @return void
function EasterEggExchangeItemView:ReturnPool()
	IconView.ReturnPool(self)
	self:ReturnPoolItemDefault()
	self:ReturnPoolItemSlot()
	self:ReturnPoolItemSelect()
	self:_RemoveListener()
end

function EasterEggExchangeItemView:CreateItemDefault()
	self:ReturnPoolItemDefault()
	---@param v RewardInBound
	for i, v in ipairs(self.listReward:GetItems()) do
		---@type ItemIconView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
		iconView:SetIconData(v:GetIconData())
		iconView:RegisterShowInfo()
		self.listItem:Add(iconView)
	end
end
function EasterEggExchangeItemView:ReturnPoolItemDefault()
	---@param v ItemIconView
	for i, v in ipairs(self.listItem:GetItems()) do
		v:ReturnPool()
	end
	---@param v ItemIconView
	for i, v in ipairs(self.listIconItem:GetItems()) do
		v:ReturnPool()
	end
	self.listIconItem:Clear()
	self.listItem:Clear()
end

function EasterEggExchangeItemView:SlotSelected()
	local listSelectId = self.eventModel.packSelectedItemDict:Get(self.easterEggExchangeRewardConfig.id)
	if listSelectId ~= nil then
		if listSelectId > 0 then
			return true
		end
	end
	return false
end

function EasterEggExchangeItemView:CreateItemSelect()
	-- index in list select id
	self:ReturnPoolItemSelect()
	---@type SlotHeroIconView
	local slot = self.listItemSlot:Get(1)
	---@type ItemIconView
	local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, slot.config.slot_hero.transform)
	local selectedId = self.eventModel.packSelectedItemDict:Get(self.easterEggExchangeRewardConfig.id)
	if (selectedId ~= nil) then
		local rewardInBound = self.poolReward:Get(selectedId):GetIconData()
		iconView:SetIconData(rewardInBound)
	end
	self.listItemSelect:Add(iconView)
	iconView:ActiveUIPool(UIPoolType.Noti, selectedId == nil)
	self:UpdateIconViewChange(iconView)
end

function EasterEggExchangeItemView:CreateItemSlot()
	self:ReturnPoolItemSlot()

	---@type SlotHeroIconView
	local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.config.rewardAnchor)
	iconView:AddListener(function()
		self:SelectItem(iconView)
	end)
	self:UpdateIconViewChange(iconView)
	self.listItemSlot:Add(iconView)
end

function EasterEggExchangeItemView:UpdateIconViewChange(iconView)
	self.iconSelectView = iconView
	self.iconSelectView:ActiveUIPool(UIPoolType.Change,self:SlotSelected(), U_Vector2(130, 130))
end

---@param iconView SlotHeroIconView
function EasterEggExchangeItemView:SelectItem(iconView)
	local listItem = List()
	local listItemSelect = List()
	---@param v EasterEggExchangeItemView
	for i, v in ipairs(self.poolReward:GetItems()) do
		local item = v:GetIconData()
		item.index = i
		listItem:Add(item)
	end
	local listSelectId = self.eventModel.packSelectedItemDict:Get(self.id)
	if listSelectId ~= nil then
		for _, v in ipairs(listSelectId:GetItems()) do
			listItemSelect:Add(listItem:Get(v))
		end
	end
	local data = {}
	data.packId = self.easterEggExchangeRewardConfig.id
	data.numberSelect = 1
	data.onSelectHeroSuccess = function(listIndex)
		self:GetEventModel()
		self.eventModel:AddSelectItem(data.packId, listIndex:Get(1))
		self:CreateItemSelect()
	end
	data.rewardSelectionList = self.poolReward
	data.selectedIndex = -1
	data.selectItems = List()
	if (listItemSelect:Count() > 0) then
		data.selectedIndex = listItemSelect:Get(1).index
		data.selectItems:Add(data.selectedIndex)
		self:CreateItemSelect()
	end
	data.opCode = OpCode.EVENT_EASTER_POINT_REWARD_SELECT
	PopupMgr.ShowPopup(UIPopupName.UIEventEasterEggExchangeRewardSelection, data)
end

--- @return void
function EasterEggExchangeItemView:_RemoveListener()
	self.config.exchangeButton.onClick:RemoveAllListeners()
end

function EasterEggExchangeItemView:ReturnPoolItemSelect()
	---@param v ItemIconView
	for i, v in ipairs(self.listItemSelect:GetItems()) do
		v:ReturnPool()
	end
	self.listItemSelect:Clear()
end

function EasterEggExchangeItemView:ReturnPoolItemSlot()
	---@param v ItemIconView
	for i, v in ipairs(self.listItemSlot:GetItems()) do
		v:ReturnPool()
	end
	self.listItemSlot:Clear()
	self.iconSelectView = nil
end

return EasterEggExchangeItemView

