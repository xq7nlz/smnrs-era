require "lua.client.scene.ui.home.uiSelectTalent.UISelectTalentModel"
require "lua.client.scene.ui.home.uiSelectTalent.UISelectTalentView"

--- @class UISelectTalent : UIBase
UISelectTalent = Class(UISelectTalent, UIBase)

--- @return void
function UISelectTalent:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectTalent:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectTalentModel()
	self.view = UISelectTalentView(self.model)
end

return UISelectTalent
