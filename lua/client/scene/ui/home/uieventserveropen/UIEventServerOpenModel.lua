
--- @class UIEventServerOpenModel : UIBaseModel
UIEventServerOpenModel = Class(UIEventServerOpenModel, UIBaseModel)

--- @return void
function UIEventServerOpenModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventServerOpen, "event_server_open")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
end

