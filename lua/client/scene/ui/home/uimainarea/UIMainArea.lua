require "lua.client.scene.ui.home.uiMainArea.UIMainAreaModel"
require "lua.client.scene.ui.home.uiMainArea.UIMainAreaView"

--- @class UIMainArea : UIBase
UIMainArea = Class(UIMainArea, UIBase)

--- @return void
function UIMainArea:Ctor()
    UIMainArea.Ctor(self)
end

function UIMainArea:Ctor()
    UIBase.Ctor(self)
    --- @type UIMainAreaView
    self.model = UIMainAreaModel()
    --- @type UIMainAreaView
    self.view = UIMainAreaView(self.model, self.ctrl)
end

return UIMainArea