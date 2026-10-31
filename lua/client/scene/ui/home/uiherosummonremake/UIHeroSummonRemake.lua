require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroSummonModelRemake"
require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroSummonViewRemake"

--- @class UIHeroSummonRemake
UIHeroSummonRemake = Class(UIHeroSummonRemake, UIBase)

--- @return void
function UIHeroSummonRemake:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIHeroSummonRemake:OnCreate()
    self.model = UIHeroSummonModelRemake()
    self.view = UIHeroSummonViewRemake(self.model)
end

return UIHeroSummonRemake
