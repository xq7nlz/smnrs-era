require "lua.client.scene.ui.home.uiTower.UITowerModel"
require "lua.client.scene.ui.home.uiTower.UITowerView"

--- @class UITower : UIBase
UITower = Class(UITower, UIBase)

--- @return void
function UITower:Ctor()
	UIBase.Ctor(self)
end

function UITower:Ctor()
    UIBase.Ctor(self)
    --- @type UITowerModel
    self.model = UITowerModel()
    --- @type UITowerView
    self.view = UITowerView(self.model)
end

return UITower
