require "lua.client.scene.ui.home.uiTempleSummon.UITempleSummonModel"
require "lua.client.scene.ui.home.uiTempleSummon.UITempleSummonView"

--- @class UITempleSummon
UITempleSummon = Class(UITempleSummon, UIBase)

--- @return void
function UITempleSummon:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UITempleSummon:OnCreate()
    UIBase.OnCreate(self)
    self.model = UITempleSummonModel()
    self.view = UITempleSummonView(self.model, self.ctrl)
end

return UITempleSummon
