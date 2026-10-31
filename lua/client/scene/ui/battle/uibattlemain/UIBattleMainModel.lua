require "lua.client.scene.ui.battle.uiBattleMain.UIButtonSpeedUp"

--- @class UIBattleMainModel : UIBaseModel
UIBattleMainModel = Class(UIBattleMainModel, UIBaseModel)

--- @return void
function UIBattleMainModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIBattleMain, "battle_main")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    self.bgDark = false
end