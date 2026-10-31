require "lua.client.scene.ui.home.uiPopupEnhanceRaiseLevel.UIPopupEnhanceRaiseLevelModel"
require "lua.client.scene.ui.home.uiPopupEnhanceRaiseLevel.UIPopupEnhanceRaiseLevelView"

--- @class UIPopupEnhanceRaiseLevel : UIBase
UIPopupEnhanceRaiseLevel = Class(UIPopupEnhanceRaiseLevel, UIBase)

--- @return void
function UIPopupEnhanceRaiseLevel:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIPopupEnhanceRaiseLevel:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIPopupEnhanceRaiseLevelModel()
    self.view = UIPopupEnhanceRaiseLevelView(self.model)
end

return UIPopupEnhanceRaiseLevel
