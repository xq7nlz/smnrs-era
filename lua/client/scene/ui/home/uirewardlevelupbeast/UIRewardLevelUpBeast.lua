require "lua.client.scene.ui.home.uiRewardLevelUpBeast.UIRewardLevelUpBeastModel"
require "lua.client.scene.ui.home.uiRewardLevelUpBeast.UIRewardLevelUpBeastView"

--- @class UIRewardLevelUpBeast : UIBase
UIRewardLevelUpBeast = Class(UIRewardLevelUpBeast, UIBase)

--- @return void
function UIRewardLevelUpBeast:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRewardLevelUpBeast:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRewardLevelUpBeastModel()
	self.view = UIRewardLevelUpBeastView(self.model)
end

return UIRewardLevelUpBeast
