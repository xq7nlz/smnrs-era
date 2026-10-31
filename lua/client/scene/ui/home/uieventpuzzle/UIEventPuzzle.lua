require "lua.client.scene.ui.home.uiEventPuzzle.UIEventPuzzleModel"
require "lua.client.scene.ui.home.uiEventPuzzle.UIEventPuzzleView"

--- @class UIEventPuzzle : UIBase
UIEventPuzzle = Class(UIEventPuzzle, UIBase)

--- @return void
function UIEventPuzzle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventPuzzle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventPuzzleModel()
	self.view = UIEventPuzzleView(self.model, self.ctrl)
end

return UIEventPuzzle
