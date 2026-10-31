require "lua.client.scene.ui.home.uiEventKazetsu.UIEventKazetsuModel"
require "lua.client.scene.ui.home.uiEventKazetsu.UIEventKazetsuView"

--- @class UIEventKazetsu : UIBase
UIEventKazetsu = Class(UIEventKazetsu, UIBase)

--- @return void
function UIEventKazetsu:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventKazetsu:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventKazetsuModel()
	self.view = UIEventKazetsuView(self.model, self.ctrl)
end

return UIEventKazetsu
