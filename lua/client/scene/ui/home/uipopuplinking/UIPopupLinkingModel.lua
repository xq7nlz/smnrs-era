
--- @class UIPopupLinkingModel : UIBaseModel
UIPopupLinkingModel = Class(UIPopupLinkingModel, UIBaseModel)

--- @return void
function UIPopupLinkingModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupLinking, "linking_popup")
end

