
--- @class UIWaveRecordDetailModel : UIBaseModel
UIWaveRecordDetailModel = Class(UIWaveRecordDetailModel, UIBaseModel)

--- @return void
function UIWaveRecordDetailModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIWaveRecordDetail, "ui_wave_detail")
	self.bgDark = true
end

