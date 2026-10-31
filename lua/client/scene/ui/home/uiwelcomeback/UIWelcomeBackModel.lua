
--- @class UIWelcomeBackModel : UIBaseModel
UIWelcomeBackModel = Class(UIWelcomeBackModel, UIBaseModel)

--- @return void
function UIWelcomeBackModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIWelcomeBack, "ui_welcome_back")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
end

function UIWelcomeBackModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(WelcomeBackTab.LOGIN)
	self.listSubEvent:Add(WelcomeBackTab.QUEST)
	self.listSubEvent:Add(WelcomeBackTab.BUNDLE)
end