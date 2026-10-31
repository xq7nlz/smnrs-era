
--- @class UIArenaChooseRivalModel : UIBaseModel
UIArenaChooseRivalModel = Class(UIArenaChooseRivalModel, UIBaseModel)

--- @return void
function UIArenaChooseRivalModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaChooseRival, "arena_choose_rival")

	self.bgDark = true
end

