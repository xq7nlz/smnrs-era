require "lua.client.core.network.starterPack.ProgressPackItemSelectOutbound"

--- @class UIPreviewStarterPackFragmentView : UIBaseView
UIPreviewStarterPackFragmentView = Class(UIPreviewStarterPackFragmentView, UIBaseView)

--- @param model UIPreviewStarterPackFragmentModel
function UIPreviewStarterPackFragmentView:Ctor(model)
	--- @type UIPreviewStarterPackFragmentConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIPreviewStarterPackFragmentModel
	self.model = model
	--- @type List<SelectReward>
	self.listReward = nil
	self.selectedIndex = nil
	---@type number
	self.packId = nil
	--- @type Dictionary
	self.selectItems = Dictionary()
end

function UIPreviewStarterPackFragmentView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UIPreviewStarterPackFragmentView:InitButtons()
	self.config.bgNone.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSelect.onClick:AddListener(function()
		self:OnClickSelect()
	end)
end

function UIPreviewStarterPackFragmentView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_artifact")
	self.config.textItem.text = LanguageUtils.LocalizeCommon("available_artifact")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

function UIPreviewStarterPackFragmentView:OnClickSelect()
	if self.selectedIndex == nil or self.selectedIndex <= 0 then
		SmartPoolUtils.ShowShortNotification(
				LanguageUtils.LocalizeCommon("select_an_artifact"))
		return
	end
	local selectIdInList = self.selectedIndex
	---@type SelectReward
	local selectHeroReward = self.listReward:Get(selectIdInList)
	local selectId = selectHeroReward.selectionId
	self.selectItems:Add(2, selectId)
	for i = 1,self.selectItems:Count() do
		local value = self.selectItems:Get(i)
		XDebug.Log("LIST SELECT HERE " .. tostring(i) .. " ___ " .. tostring(value))
	end
	local onSuccess = function()
		self.callBackSelectSuccess(self.selectItems)
		self:OnClickBackOrClose()
	end

	local outBound = ProgressPackItemSelectOutbound(self.packId,
			self.selectItems:Count(), self.selectItems)
	NetworkUtils.RequestAndCallback(OpCode.PROGRESS_PACK_ITEM_SELECT, outBound, onSuccess)
end

--- @param data {callbackClose : function}
function UIPreviewStarterPackFragmentView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.packId = data.packId
	self.callBackSelectSuccess = data.onSelectHeroSuccess
	self.listReward = data.rewardSelectionList
	self.selectedIndex = data.selectedIndex
	self.listIconData = List()
	self.listRewardIcon = List()
	self.selectRewardIcon = nil
	self.selectItems = data.selectItems

	self:InitView()
end

--- @return void
function UIPreviewStarterPackFragmentView:Hide()
	UIBaseView.Hide(self)
	for i = 1, self.listRewardIcon:Count() do
		self.listRewardIcon:Get(i):ReturnPool()
	end
	self.selectRewardIcon:ReturnPool()
end

function UIPreviewStarterPackFragmentView:InitView()
	for i = 1, self.listReward:Count() do
		---@type SelectReward
		local selectHeroReward = self.listReward:Get(i)
		---@type RewardInBound
		local rewardInBound = selectHeroReward.rewardInBound
		--- @type IconView
		local data = rewardInBound:GetIconData()
		self.listIconData:Add(data)
		--- @type RootIconView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.ItemList)
		item:SetIconData(data)
		local index = i
		item:AddListener(function()
			self:ClickItem(index)
		end)

		self.listRewardIcon:Add(item)
	end
	local data = nil
	--- @type RootIconView
	local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.ItemSelect)
	self.selectRewardIcon = item
	if self.selectedIndex == nil or self.selectedIndex <= 0 then
		--data = ItemIconData()
		--data:SetData(ResourceType.Money, MoneyType.STARTER_PACK_NONE)
		--item:SetIconData(data)

		item:ActiveUIPool(UIPoolType.IconItemSlot, true)
		item:ActiveUIPool(UIPoolType.Artifact, true)
	else
		data = self.listIconData:Get(self.selectedIndex)

		item:SetIconData(data)

		self:ClickItem(self.selectedIndex)
	end
end

---@param index number
function UIPreviewStarterPackFragmentView:ClickItem(index)
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)

	for i = 1, self.listRewardIcon:Count() do
		---@type RootIconView
		local obj = self.listRewardIcon:Get(i)
		obj:ActiveUIPool(UIPoolType.MaskSelected, index == i)
	end
	self.selectedIndex = index
	self.selectRewardIcon:SetIconData(self.listIconData:Get(index))
	self.selectRewardIcon:RegisterShowInfo()

	self.selectRewardIcon:ActiveUIPool(UIPoolType.IconItemSlot, false)
	self.selectRewardIcon:ActiveUIPool(UIPoolType.Artifact, false)
end