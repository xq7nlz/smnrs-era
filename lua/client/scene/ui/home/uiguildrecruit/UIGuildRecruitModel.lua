
--- @class UIGuildRecruitModel : UIBaseModel
UIGuildRecruitModel = Class(UIGuildRecruitModel, UIBaseModel)

--- @return void
function UIGuildRecruitModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildRecruit, "guild_recruit")

	self.bgDark = true
end

