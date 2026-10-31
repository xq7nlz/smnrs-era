

--- @class UIBaseModel
UIBaseModel = Class(UIBaseModel)

--- @return void
--- @param uiName UIPopupName
--- @param prefabName string
function UIBaseModel:Ctor(uiName, prefabName)
    --- @type UIPopupName
    self.uiName = uiName
    --- @type string
    self.prefabName = prefabName
    --- @type UIPopupType
    self.type = UIPopupType.NORMAL_POPUP
    --- @type UIPopupType
    self.bgDark = false
end

