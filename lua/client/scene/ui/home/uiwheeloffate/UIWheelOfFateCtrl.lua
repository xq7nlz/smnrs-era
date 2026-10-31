
--- @class UIWheelOfFateCtrl : UIBaseCtrl
UIWheelOfFateCtrl = Class(UIWheelOfFateCtrl, UIBaseCtrl)

--- @return void
--- @param model UIWheelOfFateModel
function UIWheelOfFateCtrl:Ctor(model)
	UIBaseCtrl.Ctor(self, model)
	--- @type UIWheelOfFateModel
	self.model = model
end

--- @return void
function UIWheelOfFateCtrl:InitItemIcon()
	self.model.itemConfigList:Clear()
	---@type List
	local listItem
	if zg.playerData:GetMethod(PlayerDataMethod.CASINO) ~= nil then
		if self.model.casinoType == CasinoType.Basic then
			listItem = zg.playerData:GetMethod(PlayerDataMethod.CASINO).baseCasinoItems
		else
			listItem = zg.playerData:GetMethod(PlayerDataMethod.CASINO).premiumCasinoItems
		end
	else
		XDebug.Error("nil PlayerData.playerCasinoInBound")
	end
	self.model.listSingleClaim:Clear()
	self.model.listClaim:Clear()
	if listItem ~= nil then
		for i = 1, listItem:Count() do
			---@type CasinoItemInBound
			local casinoItemInBound = listItem:Get(i)
			if casinoItemInBound.isSingleClaim == true then
				self.model.listSingleClaim:Add(casinoItemInBound.id)
			end
			if casinoItemInBound.isClaim == true then
				self.model.listClaim:Add(casinoItemInBound.id)
			end
			--XDebug.Log(LogUtils.ToDetail(casinoItemInBound))
			self.model.itemConfigList:Add(casinoItemInBound.reward:GetIconData())
		end
	else
		XDebug.Error("nil item playerCasinoInBound")
	end
end

--- @return boolean
function UIWheelOfFateCtrl:AddCasinoPoint1()
	---@type CasinoPriceConfig
	local casinoPriceConfig = ResourceMgr.GetCasinoConfig().casinoPriceDictionary:Get(self.model.casinoType):Get(1)
	InventoryUtils.Add(ResourceType.Money, MoneyType.CASINO_POINT, casinoPriceConfig.casinoPoint)
end

--- @return boolean
function UIWheelOfFateCtrl:AddCasinoPoint10()
	---@type CasinoPriceConfig
	local casinoPriceConfig = ResourceMgr.GetCasinoConfig().casinoPriceDictionary:Get(self.model.casinoType):Get(2)
	InventoryUtils.Add(ResourceType.Money, MoneyType.CASINO_POINT, casinoPriceConfig.casinoPoint)
end

