
--- @class UIGuildAreaModel : UIBaseModel
UIGuildAreaModel = Class(UIGuildAreaModel, UIBaseModel)

--- @return void
function UIGuildAreaModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildArea, "guild_area")
end

