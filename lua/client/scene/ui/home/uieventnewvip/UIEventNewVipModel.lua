
--- @class UIEventNewVipModel : UIBaseModel
UIEventNewVipModel = Class(UIEventNewVipModel, UIBaseModel)

--- @return void
function UIEventNewVipModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventNewVip, "ui_event_new_vip")
	self.bgDark = true
end

function UIEventNewVipModel:InitListSubEvent()
end