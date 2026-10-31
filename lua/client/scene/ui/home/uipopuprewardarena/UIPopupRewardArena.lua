require "lua.client.scene.ui.home.uiPopupRewardArena.UIPopupRewardArenaModel"
require "lua.client.scene.ui.home.uiPopupRewardArena.UIPopupRewardArenaView"

--- @class UIPopupRewardArena : UIBase
UIPopupRewardArena = Class(UIPopupRewardArena, UIBase)

--- @return void
function UIPopupRewardArena:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupRewardArena:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupRewardArenaModel()
	self.view = UIPopupRewardArenaView(self.model)
end

return UIPopupRewardArena
