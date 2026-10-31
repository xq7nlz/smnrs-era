require "lua.client.scene.ui.home.uiStarterPackNew.UIStarterPackNewItem"

--- @class UIStarterPackNewView : UIBaseView
UIStarterPackNewView = Class(UIStarterPackNewView, UIBaseView)

--- @param model UIStarterPackNewModel
function UIStarterPackNewView:Ctor(model)
	--- @type UIStarterPackNewConfig
	self.config = nil
	--- @type GroupProductConfig
	self.groupProductConfig = nil
	--- @type IapDataInBound
	self.iapDataInBound = nil
	--- @type List
	self.listOfProducts = nil
	--- @type Dictionary
	self.packItemDict = Dictionary()
	UIBaseView.Ctor(self, model)
	--- @type UIStarterPackNewModel
	self.model = model
	self.data = nil
	self.profit = nil
end

function UIStarterPackNewView:SetFx(active)
	--XDebug.Log("set active fx " .. tostring(active))
	self.config.fxButtonPrice.gameObject:SetActive(active)
end

function UIStarterPackNewView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtonListener()
	self:InitUpdateTime()
end


function UIStarterPackNewView:InitPackItemView()
	local listOfProducts = self.groupProductConfig:GetListProductConfig()
	for i = 1, listOfProducts:Count() do
		--- @type ProductConfig
		local starterPackProduct = listOfProducts:Get(i)
		local id = starterPackProduct.id
		--print("hoangpl id " .. tostring(id) .. "count " .. tostring(starterPackProduct.rewardList:Count()))
		--- @type UIStarterPackNewItem
		local uiStarterPackItem = self.packItemDict:Get(id)
		if uiStarterPackItem == nil then
			local trans = self.config.transform:Find("starter_pack_" .. i)
			if trans ~= nil then
				uiStarterPackItem = UIStarterPackNewItem(trans,self)
				self.packItemDict:Add(id, uiStarterPackItem)
			else
				XDebug.Error("There is no ui for starter pack id " .. i)
				return
			end
		end
		uiStarterPackItem:InitConfig(starterPackProduct)
		uiStarterPackItem:AddOnClickBuyListener(function()
			self:OnClickBuyPack(id)
		end)
	end
end


--- @param packId number
function UIStarterPackNewView:OnClickBuyPack(packId)
	local buyCount = self.progressPackCollection:GetBoughtCount(packId)
	--- @type ProductConfig
	local productConfig = self.groupProductConfig:FindProductConfigByPackId(packId)
	if productConfig == nil then
		XDebug.Error("StarterPack product config not found " .. tostring(packId))
		return
	end
	if buyCount >= productConfig.stock then
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		SmartPoolUtils.LogicCodeNotification(LogicCode.PURCHASE_PACK_SOLD_OUT)
	else
		BuyUtils.InitListener(function()
			--- @type UIStarterPackNewItem
			local itemView = self.packItemDict:Get(packId)
			itemView:ShowBuyState(buyCount + 1)
			self:CheckGroupStillActive()
			RxMgr.notificationPurchasePacks:Next()
		end, function(logicCode)
			XDebug.Error("Error logic code " .. tostring(logicCode))
		end)
		RxMgr.purchaseProduct:Next(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, packId))
	end
end

function UIStarterPackNewView:CheckGroupStillActive()
	local listProductConfig = self.groupProductConfig.listProductConfig
	local availablePack = listProductConfig:Count()
	for i = availablePack, 1, -1 do
		--- @type ProductConfig
		local productConfig = listProductConfig:Get(i)
		local boughtCount = self.progressPackCollection:GetBoughtCount(productConfig.id)
		if boughtCount >= productConfig.stock then
			availablePack = availablePack - 1
		end
	end
	if availablePack == 0 then
		self.iapDataInBound.progressPackData.activeProgressPackDict:RemoveByKey(self.groupId)
		self:OnClickBackOrClose()
		else
		self:OnReadyShow(self.data)
	end
end

--- @param packId number
--- @param pos number
function UIStarterPackNewView.GetItemSelect(packId, pos)
	--- @type IapDataInBound
	local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)

	--- @type Dictionary<number, List>
	local selectDict =  iapDataInBound.progressPackData.starterPackItemSelectDict
	if (selectDict == nil or selectDict:Get(packId) == nil) then
		return nil
	end
	--- @type Dictionary<number, number>
	local listSelect = selectDict:Get(packId)
	if (listSelect == nil or listSelect:Count() <= 0) then
		return nil
	end
	--for i = 1,listSelect:Count() do
	--	local value = listSelect:Get(i)
	--	XDebug.Log("LIST SELECT HERE " .. tostring(i) .. tostring(value))
	--end
	return tonumber(listSelect:Get(pos))
end

function UIStarterPackNewView:SetItemSelect(packId,listId)
	self.iapDataInBound.progressPackData:SetItemSelect(packId,listId)
	self:OnReadyShow(self.data)
end

function UIStarterPackNewView:GetRefs()
	--- @type IapDataInBound
	self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
	--- @type ProgressPackCollection
	self.progressPackCollection = self.iapDataInBound.progressPackData
	local listActiveGroupProductConfig = self.progressPackCollection
			:GetListActiveGroupByViewType(PackViewType.STARTER_PACK_NEW)
	--- @type GroupProductConfig
	self.groupProductConfig = listActiveGroupProductConfig:Get(1)
	self.groupId = self.groupProductConfig.groupId

	--- @type List
	local listProductInGroup = self.groupProductConfig:GetListProductConfig()
	--- @type ProductConfig
	local firstPack = listProductInGroup:Get(1)
	---@type ProgressProduct
	self.csv = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPackById(OpCode.PURCHASE_PROGRESS_PACK, firstPack.id)
end

function UIStarterPackNewView:RemoveUpdateTime()
	--XDebug.Log("hoangpl remove update time here")
	zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIStarterPackNewView:Hide()
	UIBaseView.Hide(self)
	self:RemoveUpdateTime()
end

function UIStarterPackNewView:OnTimeEnd()
	self:RemoveUpdateTime()
	self.iapDataInBound.progressPackData.activeProgressPackDict:RemoveByKey(self.groupId)
	RxMgr.notificationPurchasePacks:Next()
	self:OnReadyHide()
	SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
end

function UIStarterPackNewView:GetPackLayoutInfo(packId)
	local packName
	local packDesc
	local price = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, packId))
	--- @type ProductConfig
	local starterPackProduct = self.groupProductConfig:FindProductConfigByPackId(packId)
	self.profit = starterPackProduct.profit
	packName = LanguageUtils.LocalizeCommon("starter_pack_new_" .. tostring(packId))
	return packName, packDesc, price
end


function UIStarterPackNewView:ShowStarterPacksInfo()
	--- @param v UIStarterPackNewItem
	for k, v in pairs(self.packItemDict:GetItems()) do
		local packName, packDesc, price = self:GetPackLayoutInfo(k)
		v:ShowLayout(packName, packDesc, price, self.progressPackCollection:GetBoughtCount(k))
	end
end

function UIStarterPackNewView:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			local createdTime = self.progressPackCollection.activeProgressPackDict:Get(self.groupId)
			if createdTime ~= nil then
				self.timeRefresh = createdTime + self.groupProductConfig.duration - zg.timeMgr:GetServerTime()
			else
				self:OnTimeEnd()
				return
			end
			else
			self.timeRefresh = self.timeRefresh - 1
		end
		if self.timeRefresh > 0 then
			self.config.packTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
					UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh, 4)))
		else
			-- XDebug.Log("TIME REMAINING " ..  self.timeRemaining)
			self.config.packTimer.text = ""
			self:OnTimeEnd()
		end
	end
end

function UIStarterPackNewView:StartTime()
	if self.updateTime ~= nil then
		zg.timeMgr:AddUpdateFunction(self.updateTime)
	end
end

function UIStarterPackNewView:StopTime()
	if self.updateTime ~= nil then
		zg.timeMgr:RemoveUpdateFunction(self.updateTime)
	end
end

function UIStarterPackNewView:InitLocalization()
	self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("starter_pack")
	self.config.textProfit.text = LanguageUtils.LocalizeCommon("profit")
	self.config.textProfitContent.text = tostring(self.profit) .. "%"
end

function UIStarterPackNewView:InitButtonListener()
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIStarterPackNewView:OnClickBackOrClose()
	UIBaseView.OnClickBackOrClose(self)
	--zg.playerData.remoteConfig.showedStarterPackCreatedTime = self.progressPackCollection.activeProgressPackDict:Get(self.groupId)
	zg.playerData.remoteConfig.showedStarterPackLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
	zg.playerData:SaveRemoteConfig()
end



--- @param data {callbackClose : function}
function UIStarterPackNewView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.data = data
	UIBaseView.OnReadyShow(self, data)
	self:GetRefs()
	if self.groupProductConfig == nil then
		self:OnReadyHide()
		return
	end
	self:InitPackItemView()
	self:ShowStarterPacksInfo()
	zg.timeMgr:AddUpdateFunction(self.updateTime)
	self:InitLocalization()
	self:SetFx(true)
end
