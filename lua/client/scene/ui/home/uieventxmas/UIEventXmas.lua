require "lua.client.scene.ui.home.uiEventXmas.UIEventXmasModel"
require "lua.client.scene.ui.home.uiEventXmas.UIEventXmasView"

--- @class UIEventXmas : UIBase
UIEventXmas = Class(UIEventXmas, UIBase)

--- @return void
function UIEventXmas:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIEventXmas:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIEventXmasModel()
    self.view = UIEventXmasView(self.model)
end

return UIEventXmas
