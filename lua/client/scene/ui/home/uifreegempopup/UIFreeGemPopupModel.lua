
--- @class UIFreeGemPopupModel : UIBaseModel
UIFreeGemPopupModel = Class(UIFreeGemPopupModel, UIBaseModel)

--- @return void
function UIFreeGemPopupModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFreeGemPopup, "ui_free_gem")
	self.bgDark = true
end

