
--- @class UILineupDetailModel : UIBaseModel
UILineupDetailModel = Class(UILineupDetailModel, UIBaseModel)

--- @return void
function UILineupDetailModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UILineupDetail, "lineup_detail")
	--- @type UIPopupType
	self.bgDark = true
end

