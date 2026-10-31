require "lua.client.scene.ui.home.uiQuest.UIQuestModel"
require "lua.client.scene.ui.home.uiQuest.UIQuestView"

--- @class UIQuest : UIBase
UIQuest = Class(UIQuest, UIBase)

--- @return void
function UIQuest:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIQuest:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIQuestModel()
	self.view = UIQuestView(self.model, self.ctrl)
end

return UIQuest
