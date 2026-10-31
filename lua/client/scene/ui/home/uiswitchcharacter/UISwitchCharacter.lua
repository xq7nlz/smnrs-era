require "lua.client.scene.ui.home.uiSwitchCharacter.UISwitchCharacterModel"
require "lua.client.scene.ui.home.uiSwitchCharacter.UISwitchCharacterView"

--- @class UISwitchCharacter : UIBase
UISwitchCharacter = Class(UISwitchCharacter, UIBase)

--- @return void
function UISwitchCharacter:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISwitchCharacter:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISwitchCharacterModel()
	self.view = UISwitchCharacterView(self.model, self.ctrl)
end

return UISwitchCharacter
