---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupExchange.UIPopupExchangeConfig"
require "lua.client.scene.ui.common.MaterialItemView"
require "lua.client.core.network.event.ExchangeOutBound"

--- @class UIPopupExchangeView : UIBaseView
UIPopupExchangeView = Class(UIPopupExchangeView, UIBaseView)

--- @return void
--- @param model UIPopupExchangeModel
function UIPopupExchangeView:Ctor(model)
	--- @type ExchangeData
	self.exchangeData = nil
	---@type List
	self.listItem = List()
	--- @type MaterialSelectData
	self.materialSelectTotal = MaterialSelectData()
	---@type List
	self.listMaterials = List()
	self.callbackExchange = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIPopupExchangeModel
	self.model = model
end

function UIPopupExchangeView:OnReadyCreate()
	--- @type UIPopupExchangeConfig
	self.config = UIBaseConfig(self.uiTransform, UIPopupExchangeConfig, "UIPopupExchangeConfig")
	self:InitButtonListener()
end

function UIPopupExchangeView:InitLocalization()
	self.config.textTitleReward.text = LanguageUtils.LocalizeCommon("reward")
	self.config.textRequirement.text = LanguageUtils.LocalizeCommon("requirement")
	self.config.localizeExchange.text = LanguageUtils.LocalizeCommon("exchange")
	self.config.localizeNotEnough.text = LanguageUtils.LocalizeCommon("not_enough")
end

function UIPopupExchangeView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonExchange.onClick:AddListener(function()
		self:OnClickExchange()
	end)
end

function UIPopupExchangeView:OnReadyShow(result)
	self.exchangeData = result.exchangeData
	self.callbackExchange = result.callbackExchange
	self:ShowReward()
	self:ShowRequirement()
end

function UIPopupExchangeView:ShowReward()
	---@param v RewardInBound
	for i, v in ipairs(self.exchangeData.listReward:GetItems()) do
		---@type ItemIconView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemReward)
		iconView:SetIconData(v:GetIconData())
		iconView:RegisterShowInfo()
		iconView:SetActiveColor(true)
		self.listItem:Add(iconView)
	end
end

function UIPopupExchangeView:ShowRequirement()
	---@param v RewardInBound
	for i, v in ipairs(self.exchangeData.listRequirement:GetItems()) do
		---@type MaterialItemView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MaterialItemView, self.config.itemRequirement)
		iconView:SetMaterialExchange(v, self.materialSelectTotal, function ()
			self:UpdateUICanExchange()
		end)
		self.listItem:Add(iconView)
		self.listMaterials:Add(iconView)
	end
	---@param v ItemIconData
	for i, v in ipairs(self.exchangeData.listMoney:GetItems()) do
		---@type MaterialItemView
		local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MaterialItemView, self.config.itemRequirement)
		iconView:SetMoneyItem(v)
		self.listItem:Add(iconView)
	end
	self:UpdateUICanExchange()
end

--- @return void
function UIPopupExchangeView:UpdateUICanExchange()
	local canExchange = true
	---@param v MaterialItemView
	for i, v in pairs(self.listMaterials:GetItems()) do
		if v:IsEnoughMaterial() == false then
			canExchange = false
			break
		end
	end
	if canExchange then
		self.config.buttonExchange.gameObject:SetActive(true)
		self.config.notEnough:SetActive(false)
	else
		self.config.buttonExchange.gameObject:SetActive(false)
		self.config.notEnough:SetActive(true)
	end
end

--- @return void
function UIPopupExchangeView:Hide()
	UIBaseView.Hide(self)
	---@param v ItemIconView
	for i, v in ipairs(self.listItem:GetItems()) do
		v:ReturnPool()
	end
	self.listItem:Clear()
	self.listMaterials:Clear()
	self.materialSelectTotal:Clear()
end

--- @return void
function UIPopupExchangeView:OnClickExchange()
	---@type ExchangeOutBound
	local exchangeOutBound = ExchangeOutBound(self.exchangeData.id)
	---@param material MaterialItemView
	for _, material in ipairs(self.listMaterials:GetItems()) do
		if material.materialExchange ~= nil then
			---@type MaterialExchangeOutBound
			local exchangeMaterial = MaterialExchangeOutBound(material.materialExchange.materialType)
			if material.materialExchange.materialType == 0 then
				exchangeMaterial.listHero = List()
				---@param heroResource HeroResource
				for _, heroResource in ipairs(material.materialSelectLocal.listHeroSelect:GetItems()) do
					exchangeMaterial.listHero:Add(heroResource.inventoryId)
				end
			elseif material.materialExchange.materialType == 1 then
				exchangeMaterial.dictEquipment = Dictionary()
				for id, number in pairs(material.materialSelectLocal.dictEquipSelect:GetItems()) do
					exchangeMaterial.dictEquipment:Add(id, number)
				end
			elseif material.materialExchange.materialType == 2 then
				exchangeMaterial.dictArtifact = Dictionary()
				for id, number in pairs(material.materialSelectLocal.dictArtifactSelect:GetItems()) do
					exchangeMaterial.dictArtifact:Add(id, number)
				end
			end
			exchangeOutBound.listMaterials:Add(exchangeMaterial)
		end
	end

	NetworkUtils.RequestAndCallback(OpCode.EVENT_EXCHANGE, exchangeOutBound, function ()
		local resourceList = List()
		---@param heroResource HeroResource
		for _, heroResource in pairs(self.materialSelectTotal.listHeroSelect:GetItems()) do
			ClientConfigUtils.AddListItemIconData(resourceList, heroResource:GetResourceReset())
			InventoryUtils.Sub(ResourceType.Hero, heroResource)
		end
		for id, number in pairs(self.materialSelectTotal.dictEquipSelect:GetItems()) do
			InventoryUtils.Sub(ResourceType.ItemEquip, id, number)
		end
		for id, number in pairs(self.materialSelectTotal.dictArtifactSelect:GetItems()) do
			InventoryUtils.Sub(ResourceType.ItemArtifact, id, number)
		end
		if self.callbackExchange ~= nil then
			--XDebug.Log(LogUtils.ToDetail(resourceList:GetItems()))
			self.callbackExchange(resourceList)
		end
		self:OnClickBackOrClose()
		---@param material MaterialItemView
		for _, material in pairs(self.listMaterials:GetItems()) do
			material.materialSelectLocal:Clear()
		end
	end, SmartPoolUtils.LogicCodeNotification)
end