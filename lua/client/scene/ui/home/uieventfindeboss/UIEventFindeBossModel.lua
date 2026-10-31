
--- @class UIEventFindeBossModel : UIBaseModel
UIEventFindeBossModel = Class(UIEventFindeBossModel, UIBaseModel)

--- @return void
function UIEventFindeBossModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventFindeBoss, "finde_boss_popup")
end

