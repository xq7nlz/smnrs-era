
--- @class UIDefeatModel : UIBaseModel
UIDefeatModel = Class(UIDefeatModel, UIBaseModel)

--- @return void
function UIDefeatModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDefeat, "defeat_panel")
	--- @type boolean
	self.isWin = nil
	--- @type BattleResult
	self.battleResult = nil
	--- @type ClientLogDetail
	self.clientLogDetail = nil

	self.bgDark = true
end

