
--- @class UIRaidModel : UIBaseModel
UIRaidModel = Class(UIRaidModel, UIBaseModel)

--- @type number
UIRaidModel.raidBgId = nil

--- @return void
function UIRaidModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRaid, "raid")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
end

