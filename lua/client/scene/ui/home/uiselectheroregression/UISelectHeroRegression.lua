require "lua.client.scene.ui.home.uiSelectHeroRegression.UISelectHeroRegressionModel"
require "lua.client.scene.ui.home.uiSelectHeroRegression.UISelectHeroRegressionView"

--- @class UISelectHeroRegression : UIBase
UISelectHeroRegression = Class(UISelectHeroRegression, UIBase)

--- @return void
function UISelectHeroRegression:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectHeroRegression:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectHeroRegressionModel()
	self.view = UISelectHeroRegressionView(self.model)
end

return UISelectHeroRegression
