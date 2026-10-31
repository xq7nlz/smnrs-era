
--- @class UISelectItemPoolModel : UIBaseModel
UISelectItemPoolModel = Class(UISelectItemPoolModel, UIBaseModel)

--- @return void
function UISelectItemPoolModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectItemPool, "select_item_pool")

	self.bgDark = true
end

