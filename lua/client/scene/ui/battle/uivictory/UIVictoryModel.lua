
--- @class UIVictoryModel : UIBaseModel
UIVictoryModel = Class(UIVictoryModel, UIBaseModel)

--- @return void
function UIVictoryModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIVictory, "victory_panel")

	--- @type boolean
	self.isWin = nil
	--- @type BattleResult
	self.battleResult = nil
	--- @type ClientLogDetail
	self.clientLogDetail = nil

	self.bgDark = true
end

