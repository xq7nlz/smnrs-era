
--- @class UIFactionInfoModel : UIBaseModel
UIFactionInfoModel = Class(UIFactionInfoModel, UIBaseModel)

--- @return void
function UIFactionInfoModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIFactionInfo, "faction_info")

    self.bgDark = true
end