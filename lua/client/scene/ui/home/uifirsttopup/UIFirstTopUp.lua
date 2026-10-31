require "lua.client.scene.ui.home.uiFirstTopUp.UIFirstTopUpModel"
require "lua.client.scene.ui.home.uiFirstTopUp.UIFirstTopUpView"

--- @class UIFirstTopUp : UIBase
UIFirstTopUp = Class(UIFirstTopUp, UIBase)

--- @return void
function UIFirstTopUp:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFirstTopUp:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFirstTopUpModel()
	self.view = UIFirstTopUpView(self.model)
end

return UIFirstTopUp
