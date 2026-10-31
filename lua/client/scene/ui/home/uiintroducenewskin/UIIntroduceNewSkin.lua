require "lua.client.scene.ui.home.uiIntroduceNewSkin.UIIntroduceNewSkinModel"
require "lua.client.scene.ui.home.uiIntroduceNewSkin.UIIntroduceNewSkinView"

--- @class UIIntroduceNewSkin : UIBase
UIIntroduceNewSkin = Class(UIIntroduceNewSkin, UIBase)

--- @return void
function UIIntroduceNewSkin:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIIntroduceNewSkin:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIIntroduceNewSkinModel()
	self.view = UIIntroduceNewSkinView(self.model)
end

return UIIntroduceNewSkin
