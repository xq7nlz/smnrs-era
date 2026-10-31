require "lua.client.scene.ui.home.uiChooseRewardChestArena.UIChooseRewardChestArenaModel"
require "lua.client.scene.ui.home.uiChooseRewardChestArena.UIChooseRewardChestArenaView"

--- @class UIChooseRewardChestArena : UIBase
UIChooseRewardChestArena = Class(UIChooseRewardChestArena, UIBase)

--- @return void
function UIChooseRewardChestArena:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChooseRewardChestArena:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChooseRewardChestArenaModel()
	self.view = UIChooseRewardChestArenaView(self.model)
end

return UIChooseRewardChestArena
