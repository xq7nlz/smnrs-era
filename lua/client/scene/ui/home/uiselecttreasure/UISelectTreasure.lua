require "lua.client.scene.ui.home.uiSelectTreasure.UISelectTreasureModel"
require "lua.client.scene.ui.home.uiSelectTreasure.UISelectTreasureView"

--- @class UISelectTreasure : UIBase
UISelectTreasure = Class(UISelectTreasure, UIBase)

--- @return void
function UISelectTreasure:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectTreasure:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectTreasureModel()
	self.view = UISelectTreasureView(self.model)
end

return UISelectTreasure
