require "lua.client.scene.ui.home.uiCommunityTotal.UICommunityTotalModel"
require "lua.client.scene.ui.home.uiCommunityTotal.UICommunityTotalView"

--- @class UICommunityTotal : UIBase
UICommunityTotal = Class(UICommunityTotal, UIBase)

--- @return void
function UICommunityTotal:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UICommunityTotal:OnCreate()
    UIBase.OnCreate(self)
    self.model = UICommunityTotalModel()
    self.view = UICommunityTotalView(self.model, self.ctrl)
end

return UICommunityTotal
