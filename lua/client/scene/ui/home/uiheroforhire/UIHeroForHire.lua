require "lua.client.scene.ui.home.uiHeroForHire.UIHeroForHireModel"
require "lua.client.scene.ui.home.uiHeroForHire.UIHeroForHireView"

--- @class UIHeroForHire : UIBase
UIHeroForHire = Class(UIHeroForHire, UIBase)

--- @return void
function UIHeroForHire:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIHeroForHire:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIHeroForHireModel()
    self.view = UIHeroForHireView(self.model)
end

return UIHeroForHire
