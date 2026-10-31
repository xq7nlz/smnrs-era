require "lua.client.scene.ui.home.uiTavern.UITavernModel"
require "lua.client.scene.ui.home.uiTavern.UITavernView"
require "lua.client.scene.ui.home.uiTavern.UITavernCtrl"

--- @class UITavern : UIBase
UITavern = Class(UITavern, UIBase)

--- @return void
function UITavern:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITavern:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITavernModel()
	self.ctrl = UITavernCtrl(self.model)
	self.view = UITavernView(self.model, self.ctrl)
end

return UITavern
