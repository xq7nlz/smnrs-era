require "lua.client.scene.ui.home.uiEventHalloween.UIEventHalloweenModel"
require "lua.client.scene.ui.home.uiEventHalloween.UIEventHalloweenView"

--- @class UIEventHalloween : UIBase
UIEventHalloween = Class(UIEventHalloween, UIBase)

--- @return void
function UIEventHalloween:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIEventHalloween:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIEventHalloweenModel()
    self.view = UIEventHalloweenView(self.model)
end

return UIEventHalloween
