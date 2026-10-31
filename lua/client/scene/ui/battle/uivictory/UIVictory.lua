require "lua.client.scene.ui.battle.uiVictory.UIVictoryModel"
require "lua.client.scene.ui.battle.uiVictory.UIVictoryView"

--- @class UIVictory : UIBase
UIVictory = Class(UIVictory, UIBase)

--- @return void
function UIVictory:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIVictory:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIVictoryModel()
	self.view = UIVictoryView(self.model)
end

return UIVictory
