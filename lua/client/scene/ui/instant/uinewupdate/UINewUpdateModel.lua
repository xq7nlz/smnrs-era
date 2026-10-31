
--- @class UINewUpdateModel : UIBaseModel
UINewUpdateModel = Class(UINewUpdateModel, UIBaseModel)

--- @return void
function UINewUpdateModel:Ctor()
	--- @type string
	self.content = nil

	UIBaseModel.Ctor(self, UIPopupName.UINewUpdate, "popup_new_update")

	self.bgDark = true
end

