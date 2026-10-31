
--- @class UILevelUpModel : UIBaseModel
UILevelUpModel = Class(UILevelUpModel, UIBaseModel)

--- @return void
function UILevelUpModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UILevelUp, "level_up")

	--- @type UnityEngine_GameObject
	self.numberPrefab = nil

	self.bgDark = true
end

