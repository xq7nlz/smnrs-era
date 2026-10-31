require "lua.client.scene.ui.home.uiSelectTalent2.UISelectTalent2Model"
require "lua.client.scene.ui.home.uiSelectTalent2.UISelectTalent2View"

--- @class UISelectTalent2 : UIBase
UISelectTalent2 = Class(UISelectTalent2, UIBase)

--- @return void
function UISelectTalent2:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectTalent2:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectTalent2Model()
	self.view = UISelectTalent2View(self.model)
end

return UISelectTalent2
