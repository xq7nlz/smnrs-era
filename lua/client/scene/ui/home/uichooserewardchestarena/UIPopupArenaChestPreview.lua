require "lua.client.scene.ui.home.uiChooseRewardChestArena.UIPopupPreviewArenaChestModel"
require "lua.client.scene.ui.home.uiChooseRewardChestArena.UIPopupArenaChestPreviewView"

--- @class UIPopupArenaChestPreview : UIBase
UIPopupArenaChestPreview = Class(UIPopupArenaChestPreview, UIBase)

--- @return void
function UIPopupArenaChestPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupArenaChestPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupPreviewArenaChestModel()
	self.view = UIPopupArenaChestPreviewView(self.model, self.ctrl)
end

return UIPopupArenaChestPreview











