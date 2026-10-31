--- @class UIMainAreaModel : UIBaseModel
UIMainAreaModel = Class(UIMainAreaModel, UIBaseModel)

--- @return void
function UIMainAreaModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIMainArea, "main_area_ui")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    --- @type number
    self.lastLevelCheck = nil
    --- @type number
    self.lastCampaignStageCheck = nil
    self.bgDark = false
end
