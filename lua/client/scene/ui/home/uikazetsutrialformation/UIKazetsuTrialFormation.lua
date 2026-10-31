require "lua.client.scene.ui.home.uiKazetsuTrialFormation.UIKazetsuTrialFormationModel"
require "lua.client.scene.ui.home.uiKazetsuTrialFormation.UIKazetsuTrialFormationView"

--- @class UIKazetsuTrialFormation : UIBase
UIKazetsuTrialFormation = Class(UIKazetsuTrialFormation, UIBase)

--- @return void
function UIKazetsuTrialFormation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIKazetsuTrialFormation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIKazetsuTrialFormationModel()
	self.view = UIKazetsuTrialFormationView(self.model)
end

return UIKazetsuTrialFormation
