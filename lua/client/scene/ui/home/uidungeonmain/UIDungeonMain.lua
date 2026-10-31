require "lua.client.scene.ui.home.uiDungeonMain.UIDungeonMainModel"
require "lua.client.scene.ui.home.uiDungeonMain.UIDungeonMainView"

--- @class UIDungeonMain : UIBase
UIDungeonMain = Class(UIDungeonMain, UIBase)

--- @return void
function UIDungeonMain:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonMain:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonMainModel()
	self.view = UIDungeonMainView(self.model)
end

return UIDungeonMain
