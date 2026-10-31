require "lua.client.scene.ui.home.uiSelectOrb.OrbFood"

--- @class UISelectOrbModel : UIBaseModel
UISelectOrbModel = Class(UISelectOrbModel, UIBaseModel)

--- @return void
function UISelectOrbModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectOrb, "ui_select_orb")
	self.bgDark = true
	---@type List
	self.listMaterial = nil
	---@type number
	self.sortFaction = nil
	---@type boolean
	self.isSortFaction = false
	---@type Dictionary --<id, number>
	self.orbSelect = Dictionary()
	---@type Dictionary --<id, number>
	self.allOrbSelect = Dictionary()
	---@type Dictionary  --<id, number>
	self.orbResource = Dictionary()
	---@type Dictionary --<slot, id>
	self.listIdSelect = Dictionary()
	---@type number
	self.currentExp = 0
	---@type number
	self.totalExp = 0
end

--- @return void
function UISelectOrbModel:Sort()
	if self.listMaterial == nil then
		self.listMaterial = List()
	end
	self.listMaterial:Clear()

	local listOrb = List()
	listOrb:Add(OrbFood(MoneyType.WATER_ORB, InventoryUtils.GetMoney(MoneyType.WATER_ORB)))
	listOrb:Add(OrbFood(MoneyType.FIRE_ORB, InventoryUtils.GetMoney(MoneyType.FIRE_ORB)))
	listOrb:Add(OrbFood(MoneyType.ABYSS_ORB, InventoryUtils.GetMoney(MoneyType.ABYSS_ORB)))
	listOrb:Add(OrbFood(MoneyType.NATURE_ORB, InventoryUtils.GetMoney(MoneyType.NATURE_ORB)))
	listOrb:Add(OrbFood(MoneyType.DARK_ORB, InventoryUtils.GetMoney(MoneyType.DARK_ORB)))
	listOrb:Add(OrbFood(MoneyType.LIGHT_ORB, InventoryUtils.GetMoney(MoneyType.LIGHT_ORB)))
	listOrb:Add(OrbFood(MoneyType.SUN_ORB, InventoryUtils.GetMoney(MoneyType.SUN_ORB)))
	listOrb:Add(OrbFood(MoneyType.MOON_ORB, InventoryUtils.GetMoney(MoneyType.MOON_ORB)))

	---@type Dictionary
	local dictFood = Dictionary()
	---@param v OrbFood
	for _, v in pairs(listOrb:GetItems()) do
		if (self.isSortFaction == false
				or ClientConfigUtils.GetOrbByFaction(self.sortFaction) == v.orbType
				or ClientConfigUtils.GetMoonSunOrbByFaction(self.sortFaction) == v.orbType) then
			dictFood:Add(v.orbType, v.number)
		end
		self.orbResource:Add(v.orbType, v.number)
	end

	for i, v in pairs(self.orbResource:GetItems()) do
		for i1, v1 in pairs(self.allOrbSelect:GetItems()) do
			if i == i1 then
				local number = v - v1
				self.orbResource:RemoveByKey(i)
				self.orbResource:Add(i, number)
			end
		end
	end

	local listFoodMaterial = List()
	local addFood = function(orbFoodType)
		local number = dictFood:Get(orbFoodType) or 0
		if number > 0 then
			local food = OrbFood(orbFoodType, number)
			listFoodMaterial:Add(food)
		end
		dictFood:RemoveByKey(orbFoodType)
	end

	if (self.isSortFaction == false) then
		addFood(MoneyType.WATER_ORB)
		addFood(MoneyType.FIRE_ORB)
		addFood(MoneyType.ABYSS_ORB)
		addFood(MoneyType.NATURE_ORB)
		addFood(MoneyType.DARK_ORB)
		addFood(MoneyType.LIGHT_ORB)
		addFood(ClientConfigUtils.GetMoonSunOrbByFaction(self.sortFaction))
	else
		addFood(ClientConfigUtils.GetOrbByFaction(self.sortFaction))
		addFood(ClientConfigUtils.GetMoonSunOrbByFaction(self.sortFaction))
	end

	table.sort(listFoodMaterial, function(a, b)
		return a.orbType > b.orbType
	end)
	for i, v in ipairs(listFoodMaterial:GetItems()) do
		self.listMaterial:Add(v)
	end
end