--- @class UIDeletePublisherModel : UIBaseModel
UIDeletePublisherModel = Class(UIDeletePublisherModel, UIBaseModel)

--- @return void
function UIDeletePublisherModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDeletePublisher, "popup_delete_publisher")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end

