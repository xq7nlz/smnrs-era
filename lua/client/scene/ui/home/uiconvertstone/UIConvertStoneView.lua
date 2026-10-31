require "lua.client.scene.ui.home.uiUpgradeConvertStone.UIPreviewStoneView"
require "lua.libs.RandomHelper"
require "lua.client.scene.ui.common.MoneyBarLocalView"
require "lua.client.core.network.item.convertStone.ConvertStoneOutBound"
require "lua.client.core.network.item.convertStone.SaveStoneOutbound"

--- @class UIConvertStoneView : UIBaseView
UIConvertStoneView = Class(UIConvertStoneView, UIBaseView)

--- @return void
--- @param model UIConvertStoneModel
function UIConvertStoneView:Ctor(model)
	-- init variables here
	---@type UIConvertStoneConfig
	self.config = nil
	---@type UIPreviewStoneView
	self.stone1 = nil
	---@type UIPreviewStoneView
	self.stone2 = nil
	---@type UnityEngine_GameObject
	self.fxConvert = nil
	---@type function
	self.callbackComplete = nil

	--- @type MoneyBarLocalView
	self.goldBarView = nil
	--- @type MoneyBarLocalView
	self.dustBarView = nil
	---@type ConvertStoneOutBound
	self.convertStoneOutBound = ConvertStoneOutBound()
	---@type ItemCollectionInBound
	self.itemCollectionInBound = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIConvertStoneModel
	self.model = self.model
end

--- @return void
function UIConvertStoneView:OnReadyCreate()
	---@type UIConvertStoneConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.stone1 = UIPreviewStoneView(self.config.previewItem1)
	self.stone2 = UIPreviewStoneView(self.config.previewItem2)
	self.fxConvert = ResourceLoadUtils.LoadUIEffect("fx_ui_convertstone", self.config.particleUpgrade)
	self.fxConvert:SetActive(false)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonConvert.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickConvert()
	end)
	self.config.buttonSave.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSave()
	end)
end

--- @return void
function UIConvertStoneView:InitLocalization()
	local localizeConvert = LanguageUtils.LocalizeCommon("convert")
	self.config.localizeConvert.text = localizeConvert
	self.config.textTitleConvert.text = localizeConvert

	self.config.localizeSave.text = LanguageUtils.LocalizeCommon("save")
end

function UIConvertStoneView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.itemCollectionInBound = zg.playerData:GetMethod(PlayerDataMethod.ITEM_COLLECTION)
	self:_InitMoneyBar()
	self:Init(result)
end

--- @return void
function UIConvertStoneView:Init(result)
	self.model.heroResource = result.heroResource
	self.model.stoneId = result.stoneId
	self.model.convert = result.convert
	self.callbackComplete = result.callbackComplete
	self:UpdateUI()
end

--- @return void
function UIConvertStoneView:_InitMoneyBar()
	if self.goldBarView == nil then
		self.goldBarView = MoneyBarLocalView(self.config.goldRoot)
	end
	self.goldBarView:SetIconData(MoneyType.GOLD)

	if self.dustBarView == nil then
		self.dustBarView = MoneyBarLocalView(self.config.dustRoot)
	end
	self.dustBarView:SetIconData(MoneyType.STONE_DUST)
end

--- @return void
function UIConvertStoneView:_RemoveListenerMoneyBar()
	if self.goldBarView ~= nil then
		self.goldBarView:RemoveListener()
	end

	if self.dustBarView ~= nil then
		self.dustBarView:RemoveListener()
	end
end

--- @return void
function UIConvertStoneView:OnClickBackOrClose()
	self:CancelConvert()
	UIBaseView.OnClickBackOrClose(self)
end

--- @return void
function UIConvertStoneView:CancelConvert()
	local stoneSave = self.itemCollectionInBound:GetConvertingStone(self.model.heroResource.inventoryId)
	if stoneSave ~= nil then
		local requestSuccess = function()
			self.itemCollectionInBound:RemoveConvertingStone(self.model.heroResource.inventoryId)
		end
		NetworkUtils.RequestAndCallback(OpCode.ITEM_STONE_SAVE_CONVERTED, SaveStoneOutbound(self.model.heroResource.inventoryId, false), requestSuccess)
	end
end

--- @return void
function UIConvertStoneView:Hide()
	UIBaseView.Hide(self)
	if self.fxConvert ~= nil then
		self.fxConvert:SetActive(false)
	end
	self.stone1:Hide()
	self.stone2:Hide()
	self:_RemoveListenerMoneyBar()
end

--- @return void
function UIConvertStoneView:UpdateUI()
	self.model.stoneData = ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:Get(self.model.stoneId)
	self.stone1:ShowStone(self.model.stoneId)
	self:ShowConvert()
end

--- @return void
function UIConvertStoneView:ShowConvert()
	if self.model.stoneData.group <= ResourceMgr.GetEquipmentConfig().maxGroupStone then
		self.model.stoneCostConfig = ResourceMgr.GetEquipmentConfig().stoneCostDictionary:Get(self.model.stoneData.group)
		self.config.textGoldPrice.text = ClientConfigUtils.FormatNumber(self.model.stoneCostConfig.convertGold)
		self.config.textMagicStonePrice.text = ClientConfigUtils.FormatNumber(self.model.stoneCostConfig.convertDust)
	else
		self.model.stoneCostConfig = nil
	end
	self:CheckConverted()
end

--- @return void
function UIConvertStoneView:CheckConverted()
	local stoneSave = self.itemCollectionInBound:GetConvertingStone(self.model.heroResource.inventoryId)
	if stoneSave ~= nil then
		self.config.buttonSave.gameObject:SetActive(true)
		self.config.stonePanelNext:SetActive(true)
		self.stone2:ShowStone(stoneSave)
	else
		self.config.buttonSave.gameObject:SetActive(false)
		self.config.stonePanelNext:SetActive(false)
	end
end

--- @return void
function UIConvertStoneView:OnClickConvert()
	if self.model:UseResourceConvert() then
		local stone
		local readBuffer = function(buffer)
			stone = buffer:GetInt()
		end
		local requestSuccess = function()
			self.itemCollectionInBound:SetConvertingStone(self.model.heroResource.inventoryId, stone)
			if self.fxConvert.activeInHierarchy == true then
				self.fxConvert:SetActive(false)
			end
			self.fxConvert:SetActive(true)
			self:UpdateUI()
		end
		NetworkUtils.RequestAndCallback(OpCode.ITEM_STONE_CONVERT, ConvertStoneOutBound(self.model.heroResource.inventoryId, 1), requestSuccess, nil, readBuffer)
	end
end

--- @return void
function UIConvertStoneView:OnClickSave()
	local requestSuccess = function()
		self.model.stoneId = self.itemCollectionInBound:GetConvertingStone(self.model.heroResource.inventoryId)
		self.itemCollectionInBound:RemoveConvertingStone(self.model.heroResource.inventoryId)
		self:UpdateUI()
		if self.callbackComplete ~= nil then
			self.callbackComplete(self.model.stoneId)
		end
		local rewardList = List()
		local iconData = ItemIconData.CreateInstance(ResourceType.ItemStone, self.model.stoneId)
		rewardList:Add(iconData)
		--PopupMgr.ShowPopup(UIPopupName.UIPopupReward, { ["resourceList"] = rewardList, ["activeEffectBlackSmith"] = true})
		SmartPoolUtils.ShowReward1Item(iconData)
		self:UpdateUI()
	end
	NetworkUtils.RequestAndCallback(OpCode.ITEM_STONE_SAVE_CONVERTED, SaveStoneOutbound(self.model.heroResource.inventoryId, true), requestSuccess)
end


--- @return void
---@param group number
---@param keepPropertyId number
function UIConvertStoneView:GetStoneId(group, keepPropertyId)
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