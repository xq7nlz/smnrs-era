
--- @class UITowerBattleRecordModel : UIBaseModel
UITowerBattleRecordModel = Class(UITowerBattleRecordModel, UIBaseModel)

--- @return void
function UITowerBattleRecordModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITowerBattleRecord, "ui_tower_battle_record")

	self.bgDark = true
end

