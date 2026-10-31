
--- @class UIPopupFourItemModel : UIBaseModel
UIPopupFourItemModel = Class(UIPopupFourItemModel, UIBaseModel)

--- @return void
function UIPopupFourItemModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupFourItem, "popup_four_item")
	--- @type List <ItemIconData>
	self.resourceList = List()
	self.bgDark = true
end

