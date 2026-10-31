require "lua.client.scene.ui.home.uiTowerBattleRecord.UITowerBattleRecordModel"
require "lua.client.scene.ui.home.uiTowerBattleRecord.UITowerBattleRecordView"

--- @class UITowerBattleRecord : UIBase
UITowerBattleRecord = Class(UITowerBattleRecord, UIBase)

--- @return void
function UITowerBattleRecord:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITowerBattleRecord:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITowerBattleRecordModel()
	self.view = UITowerBattleRecordView(self.model)
end

return UITowerBattleRecord
