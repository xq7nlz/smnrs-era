
--- @class UIBattleLogModel : UIBaseModel
UIBattleLogModel = Class(UIBattleLogModel, UIBaseModel)

--- @return void
function UIBattleLogModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBattleLog, "panel_battle_log")

	self.maxDmg = 1
	self.maxHp = 1
	--- @type BattleResult
	self.result = nil
	--- @type ClientLogDetail
	self.clientLogDetail = nil

	self.bgDark = true
end

