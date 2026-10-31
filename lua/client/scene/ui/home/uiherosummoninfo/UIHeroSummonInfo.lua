require "lua.client.scene.ui.home.uiHeroSummonInfo.UIHeroSummonInfoModel"
require "lua.client.scene.ui.home.uiHeroSummonInfo.UIHeroSummonInfoView"

--- @class UIHeroSummonInfo : UIBase
UIHeroSummonInfo = Class(UIHeroSummonInfo, UIBase)

--- @return void
function UIHeroSummonInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHeroSummonInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIHeroSummonInfoModel()
	self.view = UIHeroSummonInfoView(self.model, self.ctrl)
end

return UIHeroSummonInfo
