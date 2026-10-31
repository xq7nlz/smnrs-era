require "lua.client.scene.ui.home.uiDefenseStageRecordList.UIDefenseStageRecordListModel"
require "lua.client.scene.ui.home.uiDefenseStageRecordList.UIDefenseStageRecordListView"

--- @class UIDefenseStageRecordList : UIBase
UIDefenseStageRecordList = Class(UIDefenseStageRecordList, UIBase)

--- @return void
function UIDefenseStageRecordList:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDefenseStageRecordList:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDefenseStageRecordListModel()
	self.view = UIDefenseStageRecordListView(self.model)
end

return UIDefenseStageRecordList
