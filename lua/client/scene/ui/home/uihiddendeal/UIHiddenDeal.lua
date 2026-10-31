require "lua.client.scene.ui.home.uiHiddenDeal.UIHiddenDealModel"
require "lua.client.scene.ui.home.uiHiddenDeal.UIHiddenDealView"

--- @class UIHiddenDeal : UIBase
UIHiddenDeal = Class(UIHiddenDeal, UIBase)

--- @return void
function UIHiddenDeal:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHiddenDeal:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIHiddenDealModel()
	self.view = UIHiddenDealView(self.model)
end

return UIHiddenDeal
