
--- @class UITavernModel : UIBaseModel
UITavernModel = Class(UITavernModel, UIBaseModel)

--- @return void
function UITavernModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITavern, "tavern")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	---@type number
	self.numberRefresh = 0
	self.gemRefresh = 0
end

