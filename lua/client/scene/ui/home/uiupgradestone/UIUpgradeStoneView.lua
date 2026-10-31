---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.UIUpgradeStone.UIUpgradeStoneConfig"
require "lua.libs.RandomHelper"
require "lua.client.scene.ui.common.MoneyBarLocalView"
require "lua.client.core.network.item.convertStone.SaveStoneOutbound"

--- @class UIUpgradeStoneView : UIBaseView
UIUpgradeStoneView = Class(UIUpgradeStoneView, UIBaseView)

--- @return void
--- @param model UIUpgradeStoneModel
function UIUpgradeStoneView:Ctor(model)
	-- init variables here
	---@type UIUpgradeStoneConfig
	self.config = nil
	---@type UIPreviewStoneView
	self.stone1 = nil
	---@type UIPreviewStoneView
	self.stone2 = nil
	---@type ItemIconView
	self.iconUpgrade = nil
	---@type UnityEngine_GameObject
	self.fxUpgrade = nil
	---@type function
	self.callbackComplete = nil
	---@type UpgradeStoneOutBound
	self.upgradeStoneOutBound = UpgradeStoneOutBound()
	---@type ItemCollectionInBound
	self.itemCollectionInBound = nil

	---@type List
	self.listStatView = List()

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIUpgradeStoneModel
	self.model = self.model
end

--- @return void
function UIUpgradeStoneView:OnReadyCreate()
	---@type UIUpgradeStoneConfig
	self.config = UIBaseConfig(self.uiTransform)
	--self.stone1 = UIPreviewStoneView(self.config.previewItem1)
	--self.stone2 = UIPreviewStoneView(self.config.previewItem2)
	self.fxUpgrade = ResourceLoadUtils.LoadUIEffect("fx_ui_upgrade_stone", self.config.particleUpgrade)
	self.fxUpgrade:SetActive(false)

	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonLock.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickLockProperty()
	end)
	self.config.buttonUpgrade.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickUpgrade()
	end)
end

--- @return void
function UIUpgradeStoneView:InitLocalization()
	local localizeUpgrade = LanguageUtils.LocalizeCommon("upgrade")
	self.config.localizeUpgrade.text = localizeUpgrade
	self.config.localizeUpgradeGem.text = localizeUpgrade
	self.config.textTitleUpgrade.text = localizeUpgrade

	self.config.localizeLockStat.text = LanguageUtils.LocalizeCommon("lock_current_stat")
end

function UIUpgradeStoneView:OnReadyShow(result)
	self.itemCollectionInBound = zg.playerData:GetMethod(PlayerDataMethod.ITEM_COLLECTION)
	self:Init(result)
end

--- @return void
function UIUpgradeStoneView:Init(result)
	self.model.heroResource = result.heroResource
	self.model.stoneId = result.stoneId
	self.model.upgrade = result.upgrade
	self.callbackComplete = result.callbackComplete
	self:UpdateUI()
end

--- @return void
function UIUpgradeStoneView:ReturnPoolListStat()
	---@param v UIStatItemUpgradeView
	for i, v in ipairs(self.listStatView:GetItems()) do
		v:ReturnPool()
	end
	self.listStatView:Clear()
end



--- @return void
function UIUpgradeStoneView:OnClickBackOrClose()
	UIBaseView.OnClickBackOrClose(self)
end

--- @return void
function UIUpgradeStoneView:CancelConvert()
	local requestSuccess = function()
		self.itemCollectionInBound:RemoveConvertingStone(self.model.heroResource.inventoryId)
	end
	NetworkUtils.RequestAndCallback(OpCode.ITEM_STONE_SAVE_CONVERTED, SaveStoneOutbound(self.model.heroResource.inventoryId, false), requestSuccess)
end

--- @return void
function UIUpgradeStoneView:Hide()
	UIBaseView.Hide(self)
	if self.fxUpgrade ~= nil then
		self.fxUpgrade:SetActive(false)
	end
	--self.stone1:Hide()
	--self.stone2:Hide()
	self.model.isKeepProperty = false
	self:ReturnPoolListStat()
end

--- @return void
function UIUpgradeStoneView:UpdateUI()
	self.model.stoneData = ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:Get(self.model.stoneId)
	--self.stone1:ShowStone(self.model.stoneId)
	self:ShowUpgrade()
end

--- @return boolean
---@param list1 List
---@param list2 List
function UIUpgradeStoneView:AddListStat(list1, list2, parent)
	--- @return Dictionary
	---@param list List
	local getDictByListStat = function(list)
		local dict = Dictionary()
		if list ~= nil then
			---@param option BaseItemOption
			for i, option in ipairs(list:GetItems()) do
				local startType = tonumber(option.params:Get(1))
				local calculation = option.params:Get(3)
				if calculation ~= nil then
					calculation = tonumber(calculation)
				else
					calculation = StatChangerCalculationType.PERCENT_ADD
				end
				if option.type == ItemOptionType.STAT_CHANGE and startType ~= StatType.POWER then
					dict:Add(startType * 100 + calculation, option)
				end
			end
		end
		return dict
	end
	local dict1 = getDictByListStat(list1)
	local dict2 = getDictByListStat(list2)
	---@param option BaseItemOption
	for i, option in pairs(dict1:GetItems()) do
		self:AddStat(option, dict2:Get(i), self.config.stat)
	end
	---@param option BaseItemOption
	for i, option in pairs(dict2:GetItems()) do
		if dict1:IsContainKey(i) == false then
			self:AddStat(nil, option, self.config.stat)
		end
	end
end

--- @return boolean
---@param option1 BaseItemOption
---@param option2 BaseItemOption
function UIUpgradeStoneView:AddStat(option1, option2, parent)
	---@type BaseItemOption
	local option = option1
	if option == nil then
		option = option2
	end
	local startType = tonumber(option.params:Get(1))
	if option.type == ItemOptionType.STAT_CHANGE and startType ~= StatType.POWER then
		local stat = ""
		local base = 0
		local upgrade = nil
		stat = LanguageUtils.LocalizeStat(startType)
		local param = nil
		if option1 ~= nil then
			param = option1.params:Get(2)
			if param ~= nil then
				base = tonumber(option1.params:Get(2))
			end
		end
		if option2 ~= nil then
			param = option2.params:Get(2)
			if param ~= nil then
				upgrade = tonumber(option2.params:Get(2))
			end
		end
		local calculation = option.params:Get(3)
		if StringUtils.IsNilOrEmpty(calculation) then
			calculation = StatChangerCalculationType.PERCENT_ADD
		else
			calculation = tonumber(calculation)
		end
		if calculation >= 3 then
			base = tostring(base)
		else
			base = string.format("%.1f%%", base * 100)
		end
		if upgrade ~= nil then
			if calculation >= 3 then
				upgrade = tostring(upgrade)
			else
				upgrade = string.format("%.1f%%", upgrade * 100)
			end
		else
			upgrade = "?"
		end

		---@type UIStatItemUpgradeView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIStatItemUpgradeView, parent)

		item:SetData(stat, base, upgrade)
		self.listStatView:Add(item)
		return true
	end
	return false
end

--- @return void
function UIUpgradeStoneView:ShowUpgrade()
	local stoneSave = self.itemCollectionInBound:GetConvertingStone(self.model.heroResource.inventoryId)
	if stoneSave ~= nil then
		self:CancelConvert()
	end

	if self.iconUpgrade == nil then
		self.iconUpgrade = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.itemUpgrade)
	end
	self.iconUpgrade:SetIconData(ItemIconData.CreateInstance( ResourceType.ItemStone, self.model.stoneId))
	--LanguageUtils.SetDescriptionItemData(self.config.stat1, ResourceType.ItemStone, self.model.stoneId)

	if self.model.stoneData.group < ResourceMgr.GetEquipmentConfig().maxGroupStone then
		self.model.stoneCostConfig = ResourceMgr.GetEquipmentConfig().stoneCostDictionary:Get(self.model.stoneData.group + 1)
		local myGold = InventoryUtils.GetMoney(MoneyType.GOLD)
		local myMagic = InventoryUtils.GetMoney(MoneyType.STONE_DUST)
		local goldColor = myGold >=  self.model.stoneCostConfig.upgradeGold and UIUtils.green_light or UIUtils.red_light
		local dustColor = myMagic >=  self.model.stoneCostConfig.upgradeDust and UIUtils.green_light or UIUtils.red_light
		self.config.textGoldPrice.text = string.format("%s/%s", UIUtils.SetColorString(goldColor, ClientConfigUtils.FormatNumber(myGold)), ClientConfigUtils.FormatNumber(self.model.stoneCostConfig.upgradeGold))
		self.config.textMagicStonePrice.text = string.format("%s/%s", UIUtils.SetColorString(dustColor, ClientConfigUtils.FormatNumber(myMagic)), ClientConfigUtils.FormatNumber(self.model.stoneCostConfig.upgradeDust))
	else
		self.model.stoneCostConfig = nil
	end
	self.config.lockCurrent:SetActive(true)
	--self.config.stonePanelNext:SetActive(false)

	---@type {itemData}
	local itemData1 = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemStone, self.model.stoneId)
	self.listBase1 = ClientConfigUtils.SplitStat(itemData1.optionList)

	self:CheckLookProperty()
end

--- @return void
function UIUpgradeStoneView:OnClickLockProperty()
	if self.model.isKeepProperty then
		self.model.isKeepProperty = false
	else
		self.model.isKeepProperty = true
	end
	self:CheckLookProperty()
end

--- @return void
function UIUpgradeStoneView:CheckLookProperty()
	if self.model.isKeepProperty == nil then
		self.model.isKeepProperty = false
	end
	self:ReturnPoolListStat()
	local listBase2 = nil
	if self.model.isKeepProperty then
		self.config.buttonTick:SetActive(true)
		self.config.objPriceKeepProperty:SetActive(true)
		self.config.objTextUpgrade:SetActive(false)
		self.config.textGemKeepProperty.text = tostring(self.model.stoneCostConfig.keepProperty)
		--self.config.stonePanelNext:SetActive(true)
		local nextId = self:GetStoneId(self.model.stoneCostConfig.group, self.model.stoneId)
		--self.stone2:ShowStone(nextId)
		--self.config.textBasicStatsUpgrade2.gameObject:SetActive(false)
		--LanguageUtils.SetDescriptionItemData(self.config.stat2, ResourceType.ItemStone, nextId)
		--self.config.stat2.gameObject:SetActive(true)

		local nextId = self:GetStoneId(self.model.stoneCostConfig.group, self.model.stoneId)
		---@type {itemData}
		local itemData2 = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemStone, nextId)
		if itemData2 ~= nil then
			listBase2 = ClientConfigUtils.SplitStat(itemData2.optionList)
		end
	else
		self.config.buttonTick:SetActive(false)
		self.config.objPriceKeepProperty:SetActive(false)
		self.config.objTextUpgrade:SetActive(true)
	end
	self:AddListStat(self.listBase1, listBase2, self.config.stat)
end

--- @return void
function UIUpgradeStoneView:ShowItemUpgrade()
	--self.config.stonePanelNext:SetActive(true)
	--self.stone2:ShowStone(self.model.stoneId)
end

--- @return void
function UIUpgradeStoneView:OnClickUpgrade()
	if self.model.heroResource.heroLevel >= 40 then
		if self.model:UseResourceUpgrade() then
			---@param upgradeStoneInBound UpgradeStoneInBound
			local requestSuccess = function(upgradeStoneInBound)
				if self.model.isKeepProperty then
					self.model.stoneId = self:GetStoneId(self.model.stoneCostConfig.group, self.model.stoneId)
				else
					self.model.stoneId = self:GetStoneId(self.model.stoneCostConfig.group)
				end
				if self.fxUpgrade.activeInHierarchy == true then
					self.fxUpgrade:SetActive(false)
				end
				self.fxUpgrade:SetActive(true)
				self.model.stoneId = upgradeStoneInBound.stoneId
				if self.callbackComplete ~= nil then
					self.callbackComplete(self.model.stoneId)
				end
				local rewardList = List()
				local iconData = ItemIconData.CreateInstance(ResourceType.ItemStone, self.model.stoneId)
				rewardList:Add(iconData)

				local touchObject
				local callbackDelay = function()
					touchObject:Enable()
					self.model.stoneData = ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:Get(self.model.stoneId)
					if self.model.stoneData.group == ResourceMgr.GetEquipmentConfig().maxGroupStone then
						PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, nil, UIPopupName.UIUpgradeStone)
					else
						self:UpdateUI()
					end
				end

				Coroutine.start(function()
					touchObject = TouchUtils.Spawn("UIUpgradeStoneView:OnClickUpgrade")
					coroutine.waitforseconds(0.6)
					callbackDelay()
				end)
			end
			self.upgradeStoneOutBound = UpgradeStoneOutBound(self.model.heroResource.inventoryId, self.model.isKeepProperty)
			self:RequestUpgradeStone(requestSuccess)
		end
	else
		SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("require_level_x"), 40))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

--- @return void
function UIUpgradeStoneView:RequestUpgradeStone(callbackSuccess)
	local callback = function(result)
		---@type UpgradeStoneInBound
		local upgradeStoneInBound
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			upgradeStoneInBound =  UpgradeStoneInBound(buffer)
		end
		local onSuccess = function()
			XDebug.Log("Upgrade Stone Success")
			if callbackSuccess ~= nil then
				callbackSuccess(upgradeStoneInBound)
			end
			RxMgr.mktTracking:Next(MktTrackingType.stoneUp, 1)
		end
		local onFailed = function(logicCode)
			SmartPoolUtils.LogicCodeNotification(logicCode)
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
	end
	NetworkUtils.Request(OpCode.ITEM_STONE_UPGRADE, self.upgradeStoneOutBound, callback)
end

--- @return void
---@param group number
---@param keepPropertyId number
function UIUpgradeStoneView:GetStoneId(group, keepPropertyId)
	if keepPropertyId then
		return keepPropertyId + 1000
	else
		local r = ClientMathUtils.randomHelper:RandomMinMax(0, 100)
		---@type StoneDataEntry
		local stoneCostConfig
		for k, v in pairs(ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:GetItems()) do
			if v.group == group and v.rate >= r and (stoneCostConfig == nil or v.rate < stoneCostConfig.rate) then
				stoneCostConfig = v
			end
		end
		if stoneCostConfig ~= nil then
			return stoneCostConfig.id
		else
			XDebug.Error("NIL stoneCostConfig group :" .. group)
		end
	end
end