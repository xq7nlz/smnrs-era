
--- @class UIFirstTopUpModel : UIBaseModel
UIFirstTopUpModel = Class(UIFirstTopUpModel, UIBaseModel)

--- @return void
function UIFirstTopUpModel:Ctor()

	UIBaseModel.Ctor(self, UIPopupName.UIFirstTopUp, "first_top_up")
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end

function UIFirstTopUpModel:OnReadyCreate()

end


