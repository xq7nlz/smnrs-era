
--- @class UIPopupEnhanceModel : UIBaseModel
UIPopupEnhanceModel = Class(UIPopupEnhanceModel, UIBaseModel)

--- @return void
function UIPopupEnhanceModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupEnhance, "popup_enhance")
	self.awaken = nil
	---@type HeroResource
	self.heroResource = nil

	self.bgDark = true
end

