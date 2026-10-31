--- @class UIQuestModel : UIBaseModel
UIQuestModel = Class(UIQuestModel, UIBaseModel)

--- @return void
function UIQuestModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIQuest, "ui_quest")
    self.type = UIPopupType.BLUR_POPUP

    self.bgDark = false
end