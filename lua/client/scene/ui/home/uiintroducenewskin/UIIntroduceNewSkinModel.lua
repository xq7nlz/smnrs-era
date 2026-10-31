
--- @class UIIntroduceNewSkinModel : UIBaseModel
UIIntroduceNewSkinModel = Class(UIIntroduceNewSkinModel, UIBaseModel)

--- @return void
function UIIntroduceNewSkinModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIIntroduceNewSkin, "introduce_new_skin")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end

