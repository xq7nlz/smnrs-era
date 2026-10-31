require "lua.client.scene.ui.home.uiArenaChooseRival.UIArenaChooseRivalModel"
require "lua.client.scene.ui.home.uiArenaChooseRival.UIArenaChooseRivalView"

--- @class UIArenaChooseRival : UIBase
UIArenaChooseRival = Class(UIArenaChooseRival, UIBase)

--- @return void
function UIArenaChooseRival:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaChooseRival:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaChooseRivalModel()
	self.view = UIArenaChooseRivalView(self.model)
end

return UIArenaChooseRival
