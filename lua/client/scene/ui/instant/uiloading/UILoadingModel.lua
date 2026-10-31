--- @class UILoadingModel : UIBaseModel
UILoadingModel = Class(UILoadingModel, UIBaseModel)

--- @return void
function UILoadingModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UILoading, "popup_loading")
    --- @type number
    self.timeCheck = 10
    --- @type number
    self.totalUpdateTimes = 50
    --- @type number
    self.stepTime = 1 / self.totalUpdateTimes
    --- @type number
    self.loadingPercent = 0
    --- @type Subject
    self.loadingSubject = Subject.Create()
    --- @type boolean
    self.isTriggerFinish = false
    --- @type UIPopupType
    self.type = UIPopupType.SPECIAL_POPUP
end

