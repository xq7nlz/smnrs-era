--- @class UIInventoryModel : UIBaseModel
UIInventoryModel = Class(UIInventoryModel, UIBaseModel)

--- @return void
function UIInventoryModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIInventory,
			"popup_inventory")
	---@type Dictionary
	self.sellItemDict = Dictionary()
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

