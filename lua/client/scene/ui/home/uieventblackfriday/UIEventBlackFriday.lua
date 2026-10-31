require "lua.client.scene.ui.home.uiEventBlackFriday.UIEventBlackFridayModel"
require "lua.client.scene.ui.home.uiEventBlackFriday.UIEventBlackFridayView"

--- @class UIEventBlackFriday : UIBase
UIEventBlackFriday = Class(UIEventBlackFriday, UIBase)

--- @return void
function UIEventBlackFriday:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIEventBlackFriday:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIEventBlackFridayModel()
    self.view = UIEventBlackFridayView(self.model)
end

return UIEventBlackFriday
