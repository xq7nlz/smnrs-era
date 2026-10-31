require "lua.client.scene.ui.home.uiGuildQuestDonate.UIGuildQuestDonateModel"
require "lua.client.scene.ui.home.uiGuildQuestDonate.UIGuildQuestDonateView"

--- @class UIGuildQuestDonate : UIBase
UIGuildQuestDonate = Class(UIGuildQuestDonate, UIBase)

--- @return void
function UIGuildQuestDonate:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildQuestDonate:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildQuestDonateModel()
	self.view = UIGuildQuestDonateView(self.model)
end

return UIGuildQuestDonate
