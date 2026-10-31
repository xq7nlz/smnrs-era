
--- @class UITutorialModel : UIBaseModel
UITutorialModel = Class(UITutorialModel, UIBaseModel)

--- @return void
function UITutorialModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITutorial, "tutorial")
	--- @type UIPopupType
	self.type = UIPopupType.SPECIAL_POPUP
end

