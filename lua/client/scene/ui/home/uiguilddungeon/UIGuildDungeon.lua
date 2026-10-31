require "lua.client.scene.ui.home.uiGuildDungeon.UIGuildDungeonModel"
require "lua.client.scene.ui.home.uiGuildDungeon.UIGuildDungeonView"

--- @class UIGuildDungeon : UIBase
UIGuildDungeon = Class(UIGuildDungeon, UIBase)

--- @return void
function UIGuildDungeon:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildDungeon:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildDungeonModel()
	self.view = UIGuildDungeonView(self.model, self.ctrl)
end

return UIGuildDungeon
