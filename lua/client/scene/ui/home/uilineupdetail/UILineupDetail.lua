require "lua.client.scene.ui.home.uiLineupDetail.UILineupDetailModel"
require "lua.client.scene.ui.home.uiLineupDetail.UILineupDetailView"

--- @class UILineupDetail : UIBase
UILineupDetail = Class(UILineupDetail, UIBase)

--- @return void
function UILineupDetail:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILineupDetail:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILineupDetailModel()
	self.view = UILineupDetailView(self.model)
end

return UILineupDetail
