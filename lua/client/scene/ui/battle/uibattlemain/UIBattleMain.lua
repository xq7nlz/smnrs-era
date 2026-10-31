require "lua.client.scene.ui.battle.uiBattleMain.UIBattleMainModel"
require "lua.client.scene.ui.battle.uiBattleMain.UIBattleMainView"

--- @class UIBattleMain : UIBase
local UIBattleMain = Class(UIBattleMain, UIBase)

--- @return void
function UIBattleMain:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIBattleMain:OnCreate()
    UIBase.OnCreate(self)

    self.model = UIBattleMainModel()
    self.view = UIBattleMainView(self.model)
end

return UIBattleMain