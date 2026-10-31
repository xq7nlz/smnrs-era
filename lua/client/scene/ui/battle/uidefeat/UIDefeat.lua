require "lua.client.scene.ui.battle.uiDefeat.UIDefeatModel"
require "lua.client.scene.ui.battle.uiDefeat.UIDefeatView"

--- @class UIDefeat : UIBase
UIDefeat = Class(UIDefeat, UIBase)

--- @return void
function UIDefeat:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDefeat:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDefeatModel()
	self.view = UIDefeatView(self.model)
end

return UIDefeat
