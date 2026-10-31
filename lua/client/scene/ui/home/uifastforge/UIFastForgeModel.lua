
--- @class UIFastForgeModel : UIBaseModel
UIFastForgeModel = Class(UIFastForgeModel, UIBaseModel)

--- @return void
function UIFastForgeModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFastForge, "fast_forge")
	---@type number
	self.idItem = nil
	---@type number
	self.materialCount = 2
	---@type EquipmentDataEntry
	self.equipmentDataConfig = nil

	self.bgDark = true
end

