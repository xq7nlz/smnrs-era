---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiUpgradeArtifact.UIUpgradeArtifactConfig"
require "lua.client.core.network.item.upgradeItemHeroInfo.UpgradeArtifactHeroInfoOutBound"

--- @class UIUpgradeArtifactView : UIBaseView
UIUpgradeArtifactView = Class(UIUpgradeArtifactView, UIBaseView)

--- @return void
--- @param model UIUpgradeArtifactModel
function UIUpgradeArtifactView:Ctor(model)
	---@type UIUpgradeArtifactConfig
	self.config = nil
	---@type ItemIconView
	self.itemEquipView1 = nil
	---@type ItemIconView
	self.itemCopy = nil
	---@type ItemIconView
	self.itemEquipView2 = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	---@type ItemIconView[]
	self.artifactMaterial = {}
	---@type UnityEngine_GameObject
	self.fxItem1 = {}
	-----@type UnityEngine_GameObject
	--self.fxItem2 = {}
	---@type UnityEngine_GameObject
	self.fxItem3 = {}
	---@type UnityEngine_GameObject
	self.fxProcess = nil
	---@type UnityEngine_GameObject
	self.fxLevelUp = nil
	---@type function
	self.callbackComplete = nil
	---@type List
	self.listStatView = List()
	--- @type UISelectRarityFilter
	self.selectType = nil
	---@type number
	self.numberCopy = 0
	---@type number
	self.fullCopy = 1

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIUpgradeArtifactModel
	self.model = self.model
end

--- @return void
function UIUpgradeArtifactView:OnReadyCreate()
	---@type UIUpgradeArtifactConfig
	self.config = UIBaseConfig(self.uiTransform)
	for i = 1, 5 do
		self.fxItem1[i] = ResourceLoadUtils.LoadUIEffect("fxui_upgrade_artifact_icon", self.config.fxItem)
		self.fxItem1[i]:SetActive(false)
		if i < 5 then
			self.fxItem1[i].transform.position = self.config.parentSlotMaterial:GetChild(i - 1).position
		else
			self.fxItem1[i].transform.position = self.config.iconCopy.position
		end
		--self.fxItem2[i] = ResourceLoadUtils.LoadUIEffect("fxui_upgrade_artifact_icon_1", self.config.fxItem)
		--self.fxItem2[i]:SetActive(false)
		self.fxItem3[i] = ResourceLoadUtils.LoadUIEffect("fx_ui_upgrade_artifact_exploder", self.config.fxLevelUp)
		self.fxItem3[i]:SetActive(false)
	end
	self.fxProcess = ResourceLoadUtils.LoadUIEffect("fx_ui_upgrade_artifact_bg", self.config.fxProcess)
	self.fxLevelUp = ResourceLoadUtils.LoadUIEffect("fx_ui_upgrade_artifact_star_new", self.config.fxLevelUp)
	self.fxLevelUp:SetActive(false)

	--- @param obj ItemIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		local id = self.model.itemSort:Get(index + 1)
		local number = self.model.artifactResource:Get(id)
		local type = ResourceType.ItemArtifact
		obj:SetIconData(ItemIconData.CreateInstance( type, id, number))
		obj:RemoveAllListeners()
		obj:AddListener(function ()
			local addOne = {["name"] = LanguageUtils.LocalizeCommon("add_one"), ["callback"] = function ()
				self:AddItem(id, 1)
			end}
			local addTen = {["name"] = LanguageUtils.LocalizeCommon("add_ten"), ["callback"] = function ()
				self:AddItem(id, 10)
			end}
			PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["position"] = self.config.viewItem.position, ["data1"] = {["type"] = type, ["id"] = id,
																						  ["button1"] = addOne,
																						  ["button2"] = addTen }})
		end)
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ItemIconView, onCreateItem, onCreateItem)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonLevelup.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickUpgrade()
	end)
	self.config.sortButton.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self.config.sortObject:SetActive(true)
	end)
	self.config.buttonCloseFilter.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self.config.sortObject:SetActive(false)
	end)

	-- Select faction
	local onChangeSelect = function (indexTab)
		if indexTab == nil then
			self.config.selectRarity.gameObject:SetActive(false)
		else
			self.config.selectRarity.gameObject:SetActive(true)
			self.config.selectRarity.transform.position = self.config.sortPopup:GetChild(indexTab - 1).position
		end
		self:Sort()
	end
	self.selectType = UISelectRarityFilter(self.config.sortPopup, nil, nil, onChangeSelect)
	--self.selectType:SetSprite(2)
end

--- @return void
function UIUpgradeArtifactView:Init(result)
	self.numberCopy = 0
	self.model.heroResource = result.heroResource
	self.model.artifactId = self.model.heroResource.heroItem:Get(SlotEquipmentType.Artifact)
	self.callbackComplete = result.callbackComplete
	self.model:LoadData()
	self.selectType:Select(1)
	if self.itemEquipView1 == nil then
		self.itemEquipView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.itemEquipInfo1)
	end
	if self.itemCopy == nil then
		self.itemCopy = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.iconCopy)
	end
	--if self.itemEquipView2 == nil then
	--	self.itemEquipView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.itemEquipInfo2)
	--end
	self:UpdateItemArtifact()
	self:UpdateItemCopy()
	self:UpdateExp()
	if self.fxLevelUp ~= nil then
		self.fxLevelUp:SetActive(false)
	end
	self:UpdateNumberMaterial()
end

--- @return void
function UIUpgradeArtifactView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("upgrade_artifact")
	self.config.localizeAutoFill.text = LanguageUtils.LocalizeCommon("auto_fill")
	self.config.localizeLevelUp.text = LanguageUtils.LocalizeCommon("upgrade")
	self.config.localizeSelectMaterial.text = LanguageUtils.LocalizeCommon("select_material_artifact")
	self.config.textWhenUpgrade.text = LanguageUtils.LocalizeCommon("when_upgrade")
end

--- @return void
function UIUpgradeArtifactView:OnReadyShow(result)
	if result ~= nil then
		self:Init(result)
	end
end

--- @return void
function UIUpgradeArtifactView:ReturnPoolListStat()
	---@param v UIStatItemUpgradeView
	for i, v in ipairs(self.listStatView:GetItems()) do
		v:ReturnPool()
	end
	self.listStatView:Clear()
end

--- @return void
function UIUpgradeArtifactView:Sort()
	local rarity = self.selectType.indexTab
	if rarity == 1 then
		rarity = nil
	else
		rarity = rarity - 1
	end
	self.model.itemSort = InventoryUtils.GetArtifact(-1, rarity)
	self.uiScroll:Resize(self.model.itemSort:Count())
end

--- @return void
function UIUpgradeArtifactView:UpdateStat()
	self:ReturnPoolListStat()
	---@type {itemData}
	local itemData1 = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemArtifact, self.model.artifactId)
	local listBase1, dictClass1, dictFaction1, dictClassFaction1, dictHeroId1 = ClientConfigUtils.SplitStat(itemData1.optionList)
	---@type {itemData}
	local itemData2 = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemArtifact, self.model.artifactId + 1)
	if itemData2 ~= nil then
		local listBase2, dictClass2, dictFaction2, dictClassFaction2, dictHeroId2 = ClientConfigUtils.SplitStat(itemData2.optionList)
		local addStat = function(option1, option2, parent)
			local startType = tonumber(option2.params:Get(1))
			if startType ~= StatType.POWER then
				local stat = ""
				local base = 0
				local upgrade = 0
				if option2.type == ItemOptionType.STAT_CHANGE then
					stat = LanguageUtils.LocalizeStat(startType)
					base = option1.params:Get(2) or 0
					upgrade = tonumber(option2.params:Get(2)) or 0
					local calculation = option2.params:Get(3)
					if StringUtils.IsNilOrEmpty(calculation) then
						calculation = nil
					else
						calculation = tonumber(calculation)
					end
					if calculation ~= nil and calculation >= 3 then
						base = tostring(base)
						upgrade = tostring(upgrade)
					else
						base = string.format("%.1f%%", base * 100)
						upgrade = string.format("%.1f%%", upgrade * 100)
					end
				elseif option2.type == ItemOptionType.DAMAGE_AGAINST then
					local key = "damage"
					for i = 1, 4 do
						---@type string
						local v = option2.params:Get(i)
						if (not StringUtils.IsNilOrEmpty(v)) then
							key = string.format("%s_%s", key, i)
						end
					end

					stat = LanguageUtils.Localize(key, LanguageUtils.EnumType)
					local index = 2
					for i = 2, 4 do
						---@type string
						local v = option2.params:Get(i)
						if (not StringUtils.IsNilOrEmpty(v)) then
							local replace = "reduce_damage"
							if i == 2 then
								replace = LanguageUtils.LocalizeListFaction(v)
							elseif i == 3 then
								replace = LanguageUtils.LocalizeListClass(v)
							elseif i == 4 then
								replace = LanguageUtils.LocalizeListFaction(v)
							end
							if (not StringUtils.IsNilOrEmpty(replace)) then
								stat = string.gsub(stat, string.format("{%s}", index), replace)
								index = index + 1
							end
						end
					end
					base = string.format("%.1f%%", tonumber(option1.params:Get(1)) * 100)
					upgrade = string.format("%.1f%%", tonumber(option2.params:Get(1)) * 100)

				elseif option2.type == ItemOptionType.REDUCE_DAMAGE_TAKEN then
					local key = "item_option_5"
					for i = 1, 4 do
						---@type string
						local v = option2.params:Get(i)
						if (not StringUtils.IsNilOrEmpty(v)) then
							key = string.format("%s_%s", key, i)
						end
					end
					stat = LanguageUtils.Localize(key, LanguageUtils.EnumType)
					local index = 1
					for i = 1, 4 do
						---@type string
						local v = option2.params:Get(i)
						if (not StringUtils.IsNilOrEmpty(v)) then
							local replace = ""
							if i == 1 then
								replace = string.format("%.1f", tonumber(v) * 100) .. "%%"
							elseif i == 2 then
								replace = LanguageUtils.LocalizeListFaction(v)
							elseif i == 3 then
								replace = LanguageUtils.LocalizeListClass(v)
							elseif i == 4 then
								replace = LanguageUtils.LocalizeListFaction(v)
							end
							if (not StringUtils.IsNilOrEmpty(replace)) then
								stat = string.gsub(stat, string.format("{%s}", index), replace)
								index = index + 1
							end
						end
					end
					base = string.format("%.1f%%", tonumber(option1.params:Get(1)) * 100)
					upgrade = string.format("%.1f%%", tonumber(option2.params:Get(1)) * 100)
				end

				---@type UIStatItemUpgradeView
				local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIStatItemUpgradeView, parent)

				item:SetData(stat, base, upgrade)
				self.listStatView:Add(item)
				return true
			end
			return false
		end

		---@param option BaseItemOption
		for i, option in ipairs(listBase2:GetItems()) do
			addStat(listBase1:Get(i), option, self.config.stat)
		end
		self.config.textBonus.gameObject:SetActive(false)
		---@param option BaseItemOption
		for heroId, listOption in pairs(dictHeroId2:GetItems()) do
			local add = false
			---@param option BaseItemOption
			for i, option in ipairs(listOption:GetItems()) do
				local listBase1 = dictHeroId1:Get(heroId)
				if addStat(listBase1:Get(i), option, self.config.statBonus) == true then
					add = true
				end
			end
			if add == true then
				self.config.textBonus.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("bonus_hero"), LanguageUtils.LocalizeNameHero(heroId))
				self.config.textBonus.gameObject:SetActive(true)
			end
			break
		end

		---@param option BaseItemOption
		for faction, listOption in pairs(dictFaction2:GetItems()) do
			local add = false
			---@param option BaseItemOption
			for i, option in ipairs(listOption:GetItems()) do
				local listBase1 = dictFaction1:Get(faction)
				if addStat(listBase1:Get(i), option, self.config.statBonus) == true then
					add = true
				end
			end
			if add == true then
				self.config.textBonus.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("bonus_faction"), LanguageUtils.LocalizeFaction(faction))
				self.config.textBonus.gameObject:SetActive(true)
			end
			break
		end
	end
end

--- @return void
function UIUpgradeArtifactView:Hide()
	UIBaseView.Hide(self)
	if self.fxLevelUp ~= nil then
		self.fxLevelUp:SetActive(false)
	end
	for i = 1, 4 do
		if self.fxItem1 ~= nil then
			self.fxItem1[i]:SetActive(false)
		end
		--if self.fxItem2 ~= nil then
		--	self.fxItem2[i]:SetActive(false)
		--end
		if self.fxItem3 ~= nil then
			self.fxItem3[i]:SetActive(false)
		end
	end
	if self.itemEquipView1 ~= nil then
		self.itemEquipView1:ReturnPool()
		self.itemEquipView1 = nil
	end
	if self.itemCopy ~= nil then
		self.itemCopy:ReturnPool()
		self.itemCopy = nil
	end
	--if self.itemEquipView2 ~= nil then
	--	self.itemEquipView2:ReturnPool()
	--	self.itemEquipView2 = nil
	--end
	for i, v in ipairs(self.artifactMaterial) do
		v:ReturnPool()
		self.artifactMaterial[i] = nil
	end
	self:ReturnPoolListStat()
end

--- @return void
function UIUpgradeArtifactView:UpdateItemArtifact()
	self.itemEquipView1:SetIconData(ItemIconData.CreateInstance( ResourceType.ItemArtifact, self.model.artifactId))
	--self.itemEquipView2:SetIconData(ItemIconData.CreateInstance( ResourceType.ItemArtifact, self.model.artifactId + 1))
	self:UpdateStat()
end

--- @return void
function UIUpgradeArtifactView:UpdateItemCopy()
	local id = (math.floor(self.model.artifactId/1000)*1000) + 1
	local totalCount = self.model.artifactResource:Get(id)

	if totalCount == nil then
		totalCount = 0
	end

	self.itemCopy:SetIconData(ItemIconData.CreateInstance( ResourceType.ItemArtifact, id))

	if totalCount > 0 then
		self.model.artifactResource:Add(id, totalCount - 1)
		self.numberCopy = 1
	else
		self.numberCopy = 0
	end
	self.uiScroll:RefreshCells()
end

--- @return void
function UIUpgradeArtifactView:UpdateNumberMaterial()
	local color
	if self:IsEnoughMaterial() then
		self.itemCopy:ActiveMask(false)
		color = UIUtils.color2
	else
		self.itemCopy:ActiveMask(true, UIUtils.sizeItem)
		color = UIUtils.color7
	end
	self.config.textFull.text = string.format("<color=#%s>%s/%s</color>", color, ClientConfigUtils.FormatNumber(self.numberCopy), ClientConfigUtils.FormatNumber(self.fullCopy))
end

--- @return void
function UIUpgradeArtifactView:IsEnoughMaterial()
	return self.numberCopy >= self.fullCopy
end

--- @return void
function UIUpgradeArtifactView:UpdateUIArtifactMaterial()
	for i = 1, 4 do
		local slot = i
		local id = self.model.listIdSelect:Get(slot)
		---@type ItemIconView
		local item = self.artifactMaterial[slot]
		if item == nil then
			item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.parentSlotMaterial:GetChild(slot - 1))
			item:RemoveAllListeners()
			item:AddListener(function ()
				self:RemoveItem(slot)
			end)
			self.artifactMaterial[slot] = item
		end
		if id ~= nil then
			local number = self.model.artifactSelect:Get(id)
			item.config.gameObject:SetActive(true)
			item:SetIconData(ItemIconData.CreateInstance( ResourceType.ItemArtifact, id, number))
		else
			item.config.gameObject:SetActive(false)
		end
	end
end

--- @return void
function UIUpgradeArtifactView:RefreshUI()
	self:UpdateUIArtifactMaterial()
	self:UpdateExp()
end

--- @return void
--- @param id number
--- @param count number
function UIUpgradeArtifactView:AddItem(id, count)
	if self.model.artifactResource:IsContainKey(id) and count > 0 and
			(self.model.artifactSelect:Count() < 4 or (self.model.artifactSelect:Count() == 4 and self.model.artifactSelect:IsContainKey(id))) then
		local totalCount = self.model.artifactResource:Get(id)
		local currentCount = self.model.artifactSelect:Get(id)
		if currentCount == nil then
			currentCount = 0
		end
		if totalCount > 0 then
			if self.model.artifactSelect:IsContainKey(id) == false then
				for i = 1, 4 do
					if self.model.listIdSelect:IsContainKey(i) == false then
						self.model.listIdSelect:Add(i, id)
						break
					end
				end
			else

			end
			if count > totalCount then
				self.model.artifactSelect:Add(id, currentCount + totalCount)
				self.model.artifactResource:Add(id, 0)
			else
				self.model.artifactSelect:Add(id, currentCount + count)
				self.model.artifactResource:Add(id, totalCount - count)
			end
		end
	end
	self:RefreshUI()
	self.uiScroll:RefreshCells()
end

--- @return void
--- @param slot number
function UIUpgradeArtifactView:RemoveItem(slot)
	local id = self.model.listIdSelect:Get(slot)
	local currentCount = self.model.artifactSelect:Get(id)
	local totalCount = self.model.artifactResource:Get(id)
	self.model.listIdSelect:RemoveByKey(slot)
	self.model.artifactSelect:RemoveByKey(id)
	self.model.artifactResource:Add(id, totalCount + currentCount)
	self:RefreshUI()
	self.uiScroll:RefreshCells()
end

--- @return void
function UIUpgradeArtifactView:UpdateExp()
	self.model.totalExp = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(self.model.artifactId + 1).expRequired
	self.model.currentExp = 0
	for k, v in pairs(self.model.artifactSelect:GetItems()) do
		---@type ArtifactDataConfig
		self.model.currentExp = self.model.currentExp + ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(k).expGain * v
	end
	local fillAmount = self.model.currentExp / self.model.totalExp
	--self.config.imageProcess.rectTransform.sizeDelta = U_Vector2(645 * fillAmount, self.config.imageProcess.rectTransform.sizeDelta.y)
	self.config.imageProcess.fillAmount = fillAmount

	if self.fxProcess ~= nil then
		if fillAmount >= 1 then
			self.fxProcess:SetActive(true)
			self.config.imageProcessFull.gameObject:SetActive(true)
		else
			self.fxProcess:SetActive(false)
			self.config.imageProcessFull.gameObject:SetActive(false)
		end
	end
	self.config.textProcess.text = tostring(self.model.currentExp) .. "/" .. tostring(self.model.totalExp)
end

--- @return void
function UIUpgradeArtifactView:OnClickUpgrade()
	if self.model.currentExp >= self.model.totalExp and self:IsEnoughMaterial() then

		local id = (math.floor(self.model.artifactId/1000)*1000) + 1
		local currentCount = self.model.artifactSelect:Get(id)
		local count = self.model.artifactSelect:Count() + 1
		--for k, v in pairs(self.model.artifactSelect:GetItems()) do
		--	if id == k then
		--		count = self.model.artifactSelect:Count()
		--		break
		--	end
		--end

		if currentCount == nil then
			currentCount = 0
		end
		self.model.artifactSelect:Add(id, currentCount + 1)

		local upgrade = function()
			local touchObject = TouchUtils.Spawn("UIUpgradeArtifactView:OnClickUpgrade")
			local timeEffect = self.model.artifactSelect:Count() * 0.2 + 2

			for i = 1, count do
				local pos
				if i == 1 then
					pos = self.config.iconCopy.position
				else
					pos = self.config.parentSlotMaterial:GetChild(i - 2).position
				end
				local obj1 = self.fxItem1[i]
				--local obj2 = self.fxItem2[i]
				local obj3 = self.fxItem3[i]
				Coroutine.start(function ()
					coroutine.waitforseconds(i * 0.2)
					obj1.transform.position = pos
					obj1:SetActive(false)
					obj1:SetActive(true)
					coroutine.waitforseconds(0.1)
					if i ~= 1 then
						---@type ItemIconView
						local item = self.artifactMaterial[i - 1]
						item.config.gameObject:SetActive(false)
					end
					coroutine.waitforseconds(0.6)
					DOTweenUtils.DOMove(obj1.transform, self.config.itemEquipInfo1.position, 0.1, U_Ease.Linear, function ()
						obj1:SetActive(false)
						obj3:SetActive(false)
						obj3:SetActive(true)
					end)
				end)
			end
			Coroutine.start(function ()
				coroutine.waitforseconds(timeEffect)
				self:UpdateItemArtifact()
				if self.fxLevelUp ~= nil then
					self.fxLevelUp.transform.position = self.itemEquipView1.config.endStar.position
					self.fxLevelUp:SetActive(false)
					self.fxLevelUp:SetActive(true)
				end
				if ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:IsContainKey(self.model.artifactId + 1) then
					self:RefreshUI()
				else
					coroutine.waitforseconds(1)
					PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, nil,UIPopupName.UIUpgradeArtifact)
				end
			end)

			for k, v in pairs(self.model.artifactSelect:GetItems()) do
				InventoryUtils.Sub(ResourceType.ItemArtifact, k, v)
			end
			self.model.artifactId = self.model.artifactId + 1
			if self.callbackComplete ~= nil then
				self.callbackComplete(self.model.artifactId)
			end
			local rewardList = List()
			rewardList:Add(ItemIconData.CreateInstance(ResourceType.ItemArtifact, self.model.artifactId, 1))
			---@type ArtifactDataEntry
			local artifactDataConfig = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(1001)
			local countReturn = math.floor((self.model.currentExp - self.model.totalExp) / artifactDataConfig.expGain)
			if countReturn > 0 then
				rewardList:Add(ItemIconData.CreateInstance(ResourceType.ItemArtifact, artifactDataConfig.id, countReturn))
				InventoryUtils.Add(ResourceType.ItemArtifact, artifactDataConfig.id, countReturn)
			end
			if ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:IsContainKey(self.model.artifactId + 1) then
				self.model.listIdSelect:Clear()
				self.model.artifactSelect:Clear()
				self.model:LoadData()
				self:Sort()
			end
			local callbackDelay = function()
				touchObject:Enable()
				self:UpdateItemCopy()
				self:UpdateNumberMaterial()
			end
			PopupMgr.ShowPopupDelay(timeEffect + 1, UIPopupName.UIPopupReward, { ["resourceList"] = rewardList }, nil, callbackDelay)
		end
		NetworkUtils.RequestAndCallback(OpCode.ITEM_ARTIFACT_UPGRADE,
				UpgradeArtifactHeroInfoOutBound(self.model.heroResource.inventoryId, self.model.artifactSelect),
				upgrade, function(code)
					SmartPoolUtils.LogicCodeNotification(code)
				end, nil)
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_resource"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

function UIUpgradeArtifactView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end