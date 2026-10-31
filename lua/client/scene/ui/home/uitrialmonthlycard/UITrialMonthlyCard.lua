require "lua.client.scene.ui.home.uiTrialMonthlyCard.UITrialMonthlyCardModel"
require "lua.client.scene.ui.home.uiTrialMonthlyCard.UITrialMonthlyCardView"

--- @class UITrialMonthlyCard : UIBase
UITrialMonthlyCard = Class(UITrialMonthlyCard, UIBase)

--- @return void
function UITrialMonthlyCard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITrialMonthlyCard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITrialMonthlyCardModel()
	self.view = UITrialMonthlyCardView(self.model)
end

return UITrialMonthlyCard
