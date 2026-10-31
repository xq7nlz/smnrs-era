require "lua.client.scene.ui.home.uiUpgradeArtifact.UIUpgradeArtifactModel"
require "lua.client.scene.ui.home.uiUpgradeArtifact.UIUpgradeArtifactView"

--- @class UIUpgradeArtifact
UIUpgradeArtifact = Class(UIUpgradeArtifact, UIBase)

--- @return void
function UIUpgradeArtifact:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIUpgradeArtifact:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIUpgradeArtifactModel()
	self.view = UIUpgradeArtifactView(self.model, self.ctrl)
end

return UIUpgradeArtifact
