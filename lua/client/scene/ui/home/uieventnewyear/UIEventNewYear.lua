require "lua.client.scene.ui.home.uiEventNewYear.UIEventNewYearModel"
require "lua.client.scene.ui.home.uiEventNewYear.UIEventNewYearView"

--- @class UIEventNewYear : UIBase
UIEventNewYear = Class(UIEventNewYear, UIBase)

--- @return void
function UIEventNewYear:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIEventNewYear:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIEventNewYearModel()
    self.view = UIEventNewYearView(self.model)
end

return UIEventNewYear
