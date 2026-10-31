--- @class UIPopupEnhanceRaiseLevelModel : UIBaseModel
UIPopupEnhanceRaiseLevelModel = Class(UIPopupEnhanceRaiseLevelModel, UIBaseModel)

--- @return void
function UIPopupEnhanceRaiseLevelModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIPopupEnhanceRaiseLevel, "popup_enhance_raise_level")
    self.bgDark = true
end