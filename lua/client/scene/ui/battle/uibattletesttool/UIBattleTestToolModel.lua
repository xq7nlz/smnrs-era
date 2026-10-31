
--- @class UIBattleTestToolModel : UIBaseModel
UIBattleTestToolModel = Class(UIBattleTestToolModel, UIBaseModel)

--- @return void
function UIBattleTestToolModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIBattleTestTool, "battle_test_tool")
    --- @type boolean
    self.isAuto = false
end