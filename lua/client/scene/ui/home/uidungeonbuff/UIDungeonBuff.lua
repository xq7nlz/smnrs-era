require "lua.client.scene.ui.home.uiDungeonBuff.UIDungeonBuffModel"
require "lua.client.scene.ui.home.uiDungeonBuff.UIDungeonBuffView"

--- @class UIDungeonBuff : UIBase
UIDungeonBuff = Class(UIDungeonBuff, UIBase)

--- @return void
function UIDungeonBuff:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonBuff:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonBuffModel()
	self.view = UIDungeonBuffView(self.model)
end

return UIDungeonBuff
