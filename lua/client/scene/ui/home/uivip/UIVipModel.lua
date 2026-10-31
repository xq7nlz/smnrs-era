
--- @class UIVipModel : UIBaseModel
UIVipModel = Class(UIVipModel, UIBaseModel)

--- @return void
function UIVipModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIVip, "vip")

	self.bgDark = true
end

