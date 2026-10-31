require "lua.client.scene.ui.home.uiGuildQuest.UIGuildQuestModel"
require "lua.client.scene.ui.home.uiGuildQuest.UIGuildQuestView"

--- @class UIEventGuildQuest : UIBase
UIEventGuildQuest = Class(UIEventGuildQuest, UIBase)

--- @return void
function UIEventGuildQuest:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventGuildQuest:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildQuestModel()
	self.view = UIGuildQuestView(self.model, self.ctrl)
end

return UIEventGuildQuest
