
--- @class UIBlackSmithModel : UIBaseModel
UIBlackSmithModel = Class(UIBlackSmithModel, UIBaseModel)

--- @return void
function UIBlackSmithModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBlackSmith, "black_smith")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	---@type number
	self.materialCount = 3
	---@type List --<id>
	self.itemSort = List()
	---@type List --<id>
	self.itemSortWeapon = ClientConfigUtils.GetEquipmentBlackSmith(EquipmentType.Weapon, -1)
	---@type List --<id>
	self.itemSortArmor = ClientConfigUtils.GetEquipmentBlackSmith(EquipmentType.Armor, -1)
	---@type List --<id>
	self.itemSortHelm = ClientConfigUtils.GetEquipmentBlackSmith(EquipmentType.Helm, -1)
	---@type List --<id>
	self.itemSortAccessory = ClientConfigUtils.GetEquipmentBlackSmith(EquipmentType.Accessory, -1)
	---@type List --<id>
	self.itemBlackSmith = ClientConfigUtils.GetEquipmentBlackSmith()

	---@type number
	self.selectItemIndex = 1
	---@type number
	self.currentId = nil
	---@type number
	self.priceForge = nil
	---@type number
	self.priceMagicCrystalForge = nil

	---@type Dictionary
	self.equipmentDict = Dictionary()
end


---@return RewardInBound
function UIBlackSmithModel:GetUseGold()
	return RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, self.priceForge)
end

---@return RewardInBound
function UIBlackSmithModel:GetUseMagicCrystal()
	return RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.MAGIC_CRYSTAL, self.priceMagicCrystalForge)
end