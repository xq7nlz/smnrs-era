require "lua.client.utils.Rx.Subject"
require "lua.client.utils.Rx.Number"
require "lua.client.scene.ui.UIBaseModel"
require "lua.client.scene.ui.UIBaseCtrl"
require "lua.client.scene.ui.UIBaseView"
--- @class UIBase
UIBase = Class(UIBase)

--- @return void
function UIBase:Ctor()
    --- @type UIBaseModel
    self.model = nil
    --- @type UIBaseView
    self.view = nil
    --- @type UIBaseCtrl
    self.ctrl = nil

    self:OnCreate()
end

--- @return void
function UIBase:OnCreate()

end

