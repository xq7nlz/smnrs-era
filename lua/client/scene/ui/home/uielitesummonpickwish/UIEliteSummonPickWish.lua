require "lua.client.scene.ui.home.uiEliteSummonPickWish.UIEliteSummonPickWishModel"
require "lua.client.scene.ui.home.uiEliteSummonPickWish.UIEliteSummonPickWishView"

--- @class UIEliteSummonPickWish : UIBase
UIEliteSummonPickWish = Class(UIEliteSummonPickWish, UIBase)

--- @return void
function UIEliteSummonPickWish:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEliteSummonPickWish:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEliteSummonPickWishModel()
	self.view = UIEliteSummonPickWishView(self.model)
end

return UIEliteSummonPickWish
