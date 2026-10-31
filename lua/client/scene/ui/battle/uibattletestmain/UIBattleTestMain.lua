require "lua.client.scene.ui.battle.uiBattleMain.UIBattleMainModel"
require "lua.client.scene.ui.battle.UIBattleTestMain.UIBattleTestMainView"

--- @class UIBattleTestMain : UIBase
local UIBattleTestMain = Class(UIBattleTestMain, UIBase)

--- @return void
function UIBattleTestMain:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIBattleTestMain:OnCreate()
    UIBase.OnCreate(self)

    self.model = UIBattleMainModel()
    self.view = UIBattleTestMainView(self.model, self.ctrl)
end

return UIBattleTestMain