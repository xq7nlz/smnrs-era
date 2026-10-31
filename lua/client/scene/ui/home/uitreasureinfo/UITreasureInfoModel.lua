
--- @class UITreasureInfoModel : UIBaseModel
UITreasureInfoModel = Class(UITreasureInfoModel, UIBaseModel)

--- @return void
function UITreasureInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITreasureInfo, "treasure_info")
	self.bgDark = true
end

