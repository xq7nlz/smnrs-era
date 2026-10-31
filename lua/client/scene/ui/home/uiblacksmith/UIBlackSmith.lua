require "lua.client.scene.ui.home.uiBlackSmith.UIBlackSmithModel"
require "lua.client.scene.ui.home.uiBlackSmith.UIBlackSmithView"

--- @class UIBlackSmith : UIBase
UIBlackSmith = Class(UIBlackSmith, UIBase)

--- @return void
function UIBlackSmith:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBlackSmith:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBlackSmithModel()
	self.view = UIBlackSmithView(self.model)
end

return UIBlackSmith
