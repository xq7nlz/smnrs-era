require "lua.client.scene.ui.home.uiConvertStone.UIConvertStoneModel"
require "lua.client.scene.ui.home.uiConvertStone.UIConvertStoneView"

--- @class UIConvertStone : UIBase
UIConvertStone = Class(UIConvertStone, UIBase)

--- @return void
function UIConvertStone:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIConvertStone:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIConvertStoneModel()
	self.view = UIConvertStoneView(self.model)
end

return UIConvertStone
