
require "lua.client.core.network.event.eventMergeServer.SelectItemBundleOutBound"

--- @class UIPreviewServerWeekFragmentView : UIBaseView
UIPreviewServerWeekFragmentView = Class(UIPreviewServerWeekFragmentView, UIBaseView)

--- @param model UIPreviewServerWeekFragmentModel
function UIPreviewServerWeekFragmentView:Ctor(model)
	--- @type UIPreviewServerWeekFragmentConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIPreviewServerWeekFragmentModel
	self.model = model
	--- @type List<SelectReward>
	self.listReward = nil
	self.selectedIndex = nil
	---@type number
	self.packId = nil
	--- @type List
	self.selectItems = List()
	--- @type UILoopScroll
	self.uiScroll = nil

	self.curSelectedIndex = nil
end

function UIPreviewServerWeekFragmentView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitScroll()
	self:InitButtons()
end

function UIPreviewServerWeekFragmentView:InitButtons()
	self.config.bgNone.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSelect.onClick:AddListener(function()
		self:OnClickSelect()
	end)
end

function UIPreviewServerWeekFragmentView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_hero_fragment")
	self.config.textItem.text = LanguageUtils.LocalizeCommon("available_hero_fragment")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

function UIPreviewServerWeekFragmentView:OnClickSelect()
	if self.selectedIndex == nil or self.selectedIndex <= 0 then
		SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_item_server_week_bundle"), self.numberSelect))
		--[[		SmartPoolUtils.ShowShortNotification(
                        LanguageUtils.LocalizeCommon("select_an_artifact"))]]
		return
	end
	local selectIdInList = self.selectedIndex
	---@type RewardInBound
	local selectHeroReward = self.listReward:Get(selectIdInList)
	local selectId = selectHeroReward.indexId
	self.selectItems = List()
	self.selectItems:Add(selectId)
	--[[	self.selectItems:Add(2, selectId)
        for i = 1,self.selectItems:Count() do
            local value = self.selectItems:Get(i)
            --XDebug.Log("LIST SELECT HERE " .. tostring(i) .. " ___ " .. tostring(value))
        end]]
	local onSuccess = function()
		self.callBackSelectSuccess(self.selectItems)
		self:OnClickBackOrClose()
	end

	local outBound = SelectItemBundleOutBound(self.packId,
			self.selectItems)
	--XDebug.Log("CALL OPCODE " .. tostring(self.opCode))
	NetworkUtils.RequestAndCallback(self.opCode, outBound, onSuccess)
end

--- @param data {callbackClose : function}
function UIPreviewServerWeekFragmentView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.numberSelect = data.numberSelect
	self.packId = data.packId
	self.callBackSelectSuccess = data.onSelectHeroSuccess
	self.listReward = data.rewardSelectionList
	self.selectedIndex = data.selectedIndex
	self.listIconData = List()
	self.listRewardIcon = List()
	self.selectRewardIcon = nil
	self.selectItems = data.selectItems
	---@type OpCode
  	self.opCode = data.opCode
	self:InitView()
	self.uiScroll:Resize(self.listReward:Count())
end

function UIPreviewServerWeekFragmentView:InitScroll()

	--- @param obj RootIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		local i = index + 1
		local rewardInBound = self.listReward:Get(i)
		local iconData = rewardInBound:GetIconData()
		obj:SetIconData(iconData)
		obj:RemoveAllListeners()
		obj:AddListener(function()
			self:ClickItem(i, obj)
		end)
		obj:ActiveUIPool(UIPoolType.MaskSelected, self.selectedIndex == i)
		--self.listRewardIcon:Add(obj)
	end
	self.uiScroll = UILoopScroll(self.config.loopScroll, UIPoolType.RootIconView, onCreateItem)


	--[[	for i = 1, self.listReward:Count() do
            ---@type SelectReward
            local rewardInBound = self.listReward:Get(i)
            ]]--[[		---@type RewardInBound
                local rewardInBound = selectHeroReward.rewardInBound]]--[[
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
	end]]

end

--- @return void
function UIPreviewServerWeekFragmentView:Hide()
	UIBaseView.Hide(self)
--[[	for i = 1, self.listRewardIcon:Count() do
		self.listRewardIcon:Get(i):ReturnPool()
	end]]
	self.uiScroll:Hide()
	self.selectRewardIcon:ReturnPool()
end

function UIPreviewServerWeekFragmentView:InitView()
	self.listRewardIcon = List()
	for i = 1, self.listReward:Count() do
		local reward = self.listReward:Get(i)
		self.listIconData:Add(reward:GetIconData())
		--self.listRewardIcon:Add(reward:GetIconData())
	end

	local data = nil
	--- @type RootIconView
	local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.ItemSelect)
	self.selectRewardIcon = item
	if self.selectedIndex == nil or self.selectedIndex <= 0 then

		item:ActiveUIPool(UIPoolType.IconItemSlot, true)
		item:ActiveUIPool(UIPoolType.FrameRandom, true)
	else
		data = self.listReward:Get(self.selectedIndex):GetIconData()
		--data = self.listIconData:Get(self.selectedIndex)
		item:SetIconData(data)
		--self:ClickItem(self.selectedIndex, nil )
	end
end





--[[
function UIPreviewServerWeekFragmentView:InitView()
	for i = 1, self.listReward:Count() do
		---@type SelectReward
		local rewardInBound = self.listReward:Get(i)
]]--[[		---@type RewardInBound
		local rewardInBound = selectHeroReward.rewardInBound]]--[[
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

		item:ActiveUIPool(UIPoolType.IconItemSlot, true)
		item:ActiveUIPool(UIPoolType.Artifact, true)
	else
		data = self.listIconData:Get(self.selectedIndex)

		item:SetIconData(data)

		self:ClickItem(self.selectedIndex)
	end
end]]

--- @param obj RootIconView
--- @param index number
function UIPreviewServerWeekFragmentView:ClickItem(index)
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
--[[	for i = 1, self.listRewardIcon:Count() do
		---@type RootIconView
		obj:ActiveUIPool(UIPoolType.MaskSelected, index == i)
	end]]
	self.selectedIndex = index
	self.selectRewardIcon:SetIconData(self.listIconData:Get(index))
	self.selectRewardIcon:RegisterShowInfo()
	self.selectRewardIcon:ActiveUIPool(UIPoolType.IconItemSlot, false)
	self.selectRewardIcon:ActiveUIPool(UIPoolType.Artifact, false)
	self.uiScroll:Resize(self.listReward:Count())
end