
--- @class UISelectItemInventoryModel : UIBaseModel
UISelectItemInventoryModel = Class(UISelectItemInventoryModel, UIBaseModel)

--- @return void
function UISelectItemInventoryModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectItemInventory, "select_item_inventory")
	--- @type List <id>
	self.itemSort = List()

	self.bgDark = true
end

