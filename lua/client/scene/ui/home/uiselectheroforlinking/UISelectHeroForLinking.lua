require "lua.client.scene.ui.home.uiSelectHeroForLinking.UISelectHeroForLinkingModel"
require "lua.client.scene.ui.home.uiSelectHeroForLinking.UISelectHeroForLinkingView"

--- @class UISelectHeroForLinking : UIBase
UISelectHeroForLinking = Class(UISelectHeroForLinking, UIBase)

--- @return void
function UISelectHeroForLinking:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectHeroForLinking:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectHeroForLinkingModel()
	self.view = UISelectHeroForLinkingView(self.model)
end

return UISelectHeroForLinking
