
--- @class UISwitchCharacterModel : UIBaseModel
UISwitchCharacterModel = Class(UISwitchCharacterModel, UIBaseModel)

--- @return void
function UISwitchCharacterModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISwitchCharacter, "switch_character")
end

