require "lua.client.scene.ui.home.uiDefenseWaveRecordView.UIDefenseWaveRecordViewModel"
require "lua.client.scene.ui.home.uiDefenseWaveRecordView.UIDefenseWaveRecordViewView"

--- @class UIDefenseWaveRecordView : UIBase
UIDefenseWaveRecordView = Class(UIDefenseWaveRecordView, UIBase)

--- @return void
function UIDefenseWaveRecordView:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDefenseWaveRecordView:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDefenseWaveRecordViewModel()
	self.view = UIDefenseWaveRecordViewView(self.model)
end

return UIDefenseWaveRecordView
