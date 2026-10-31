
--- @class UIDefenseWaveRecordViewModel : UIBaseModel
UIDefenseWaveRecordViewModel = Class(UIDefenseWaveRecordViewModel, UIBaseModel)

--- @return void
function UIDefenseWaveRecordViewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDefenseWaveRecordView, "defense_wave_record")
end

