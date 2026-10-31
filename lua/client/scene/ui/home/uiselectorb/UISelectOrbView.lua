
--- @class UISelectOrbView : UIBaseView
UISelectOrbView = Class(UISelectOrbView, UIBaseView)

--- @param model UISelectOrbModel
function UISelectOrbView:Ctor(model)
	--- @type UISelectOrbConfig
	self.config = nil
	---@type RootIconView[]
	self.material = {}
	--- @type function
	self.callbackSelect = nil
	--- @type number
	self.idSlotCount = nil
	UIBaseView.Ctor(self, model)
	--- @type UISelectOrbModel
	self.model = model
end

function UISelectOrbView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()

	--- @param obj RootIconView
	--- @param index number
	local onCreateItem = function(obj, _index)
		---@type OrbFood
		local orbFood = self.model.listMaterial:Get(_index + 1)
		local number = self.model.orbResource:Get(orbFood.orbType)
		if orbFood.orbType ~= nil then
			local itemIconData = ItemIconData.CreateInstance(ResourceType.Money, orbFood.orbType, number)
			obj:SetIconData(itemIconData)
			obj:RemoveAllListeners()
			obj:AddListener(function()
				if self.model.currentExp >= self.model.totalExp then
					SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_total_exp"))
				elseif number == 0 then
					SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_have_enought_food"))
				elseif self.model.orbSelect:Count() == self.idSlotCount and self.model.orbSelect:IsContainKey(orbFood.orbType) == false then
					SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_select"))
				else
					local data = {}
					data.moneyType = orbFood.orbType
					data.number = number
					data.callbackSelect = function(number)
						self:AddItem(orbFood.orbType, number)
					end
					PopupMgr.ShowPopup(UIPopupName.UISelectOrbPopup, data)
				end
			end)
		end
	end

	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem, onCreateItem)
	self.uiScroll:SetUpMotion(MotionConfig(nil, nil, nil, 0.02, 3))
end

function UISelectOrbView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_orb_title")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

--- @param data {callbackClose : function}
function UISelectOrbView:OnReadyShow(result)
	UIBaseView.OnReadyShow(self, result)
	self:Init(result)
end

--- @return void
function UISelectOrbView:Init(result)
	self.model.sortFaction = result.sortFaction
	self.model.isSortFaction = result.isSortFaction
	self.model.totalExp = result.maxNumber
	self.model.allOrbSelect = result.allOrbSelect
	self.idSlotCount = result.idSlotCount
	for i = 1, self.idSlotCount do
		self.config.parentSlotMaterial:GetChild(i - 1).gameObject:SetActive(true)
	end
	if result.orbSelect == nil then
		if self.model.orbSelect == nil then
			self.model.orbSelect = List()
		else
			self.model.orbSelect:Clear()
		end
	else
		self.model.orbSelect:Clear()
		for i, v in pairs(result.orbSelect:GetItems()) do
			self.model.orbSelect:Add(i,v)
		end
	end
	if result.listIdSelect == nil then
		if self.model.listIdSelect == nil then
			self.model.listIdSelect = List()
		else
			self.model.listIdSelect:Clear()
		end
	else
		self.model.listIdSelect:Clear()
		for i, v in pairs(result.listIdSelect:GetItems()) do
			self.model.listIdSelect:Add(i,v)
		end
	end
	self.callbackSelect = result.callbackSelect
	self:UpdateUIMaterial()
	self:UpdateExp()
	self:Sort()
end

--- @return void
function UISelectOrbView:Sort()
	self.model:Sort()
	self.uiScroll:Resize(self.model.listMaterial:Count())
end

--- @return void
--- @param id number
--- @param count number
function UISelectOrbView:AddItem(id, count)
	if self.model.orbResource:IsContainKey(id) and count > 0 and
			(self.model.orbSelect:Count() < self.idSlotCount or (self.model.orbSelect:Count() == self.idSlotCount and self.model.orbSelect:IsContainKey(id))) then
		local totalCount = self.model.orbResource:Get(id)
		local currentCount = self.model.orbSelect:Get(id)
		if currentCount == nil then
			currentCount = 0
		end
		if totalCount > 0 then
			if self.model.orbSelect:IsContainKey(id) == false then
				for i = 1, self.idSlotCount do
					if self.model.listIdSelect:IsContainKey(i) == false then
						self.model.listIdSelect:Add(i, id)
						break
					end
				end
			end

			if count + self.model.currentExp > self.model.totalExp then
				self.model.orbResource:Add(id, totalCount - (self.model.totalExp - self.model.currentExp))
				self.model.orbSelect:Add(id, currentCount + (self.model.totalExp - self.model.currentExp))
			else
				self.model.orbSelect:Add(id, currentCount + count)
				self.model.orbResource:Add(id, totalCount - count)
			end
		end
	end
	self:RefreshUI()
	self.uiScroll:RefreshCells()
end

--- @return void
--- @param slot number
function UISelectOrbView:RemoveItem(slot)
	local id = self.model.listIdSelect:Get(slot)
	local currentCount = self.model.orbSelect:Get(id)
	local totalCount = self.model.orbResource:Get(id)
	self.model.listIdSelect:RemoveByKey(slot)
	self.model.orbSelect:RemoveByKey(id)
	self.model.orbResource:Add(id, totalCount + currentCount)
	self:RefreshUI()
	self.uiScroll:RefreshCells()
end

--- @return void
function UISelectOrbView:RefreshUI()
	self:UpdateUIMaterial()
	self:UpdateExp()
end

--- @return void
function UISelectOrbView:OnClickSelect()
	PopupMgr.HidePopup(self.model.uiName)
	if self.callbackSelect ~= nil then
		self.callbackSelect(self.model.listIdSelect, self.model.orbSelect)
	end
end

--- @return void
function UISelectOrbView:UpdateUIMaterial()
	for i = 1, self.idSlotCount do
		local slot = i
		local id = self.model.listIdSelect:Get(slot)
		---@type RootIconView
		local item = self.material[slot]
		if item == nil then
			item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.parentSlotMaterial:GetChild(slot - 1))
			self.material[slot] = item
		end
		if id ~= nil then
			local number = self.model.orbSelect:Get(id)
			item.config.gameObject:SetActive(true)
			item:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, id, number))
			item:RemoveAllListeners()
			item:AddListener(function ()
				self:RemoveItem(slot)
			end)
		else
			item.config.gameObject:SetActive(false)
		end
	end
end

--- @return void
function UISelectOrbView:UpdateExp()
	self.model.currentExp = 0
	for k, v in pairs(self.model.orbSelect:GetItems()) do
		self.model.currentExp = self.model.currentExp + v
	end
	local fillAmount = self.model.currentExp / self.model.totalExp
	self.config.imageProcess.fillAmount = fillAmount

	if fillAmount >= 1 then
		self.config.imageProcessFull.gameObject:SetActive(true)
	else
		self.config.imageProcessFull.gameObject:SetActive(false)
	end

	self.config.textProcess.text = tostring(self.model.currentExp) .. "/" .. tostring(self.model.totalExp)
end

function UISelectOrbView:InitButtons()
	self.config.close.onClick:RemoveAllListeners()
	self.config.close.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSelect.onClick:AddListener(function()
		self:OnClickSelect()
	end)
end

--- @return void
function UISelectOrbView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()

	for i, v in ipairs(self.material) do
		v:ReturnPool()
		self.material[i] = nil
	end

	for i = 1, self.idSlotCount do
		self.config.parentSlotMaterial:GetChild(i - 1).gameObject:SetActive(false)
	end
end
