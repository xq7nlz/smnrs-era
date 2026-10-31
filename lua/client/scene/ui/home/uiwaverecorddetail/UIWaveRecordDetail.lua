require "lua.client.scene.ui.home.uiWaveRecordDetail.UIWaveRecordDetailModel"
require "lua.client.scene.ui.home.uiWaveRecordDetail.UIWaveRecordDetailView"

--- @class UIWaveRecordDetail : UIBase
UIWaveRecordDetail = Class(UIWaveRecordDetail, UIBase)

--- @return void
function UIWaveRecordDetail:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIWaveRecordDetail:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIWaveRecordDetailModel()
	self.view = UIWaveRecordDetailView(self.model)
end

return UIWaveRecordDetail
