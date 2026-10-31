--- @class UICommunityTotalModel : UIBaseModel
UICommunityTotalModel = Class(UICommunityTotalModel, UIBaseModel)

--- @return void
function UICommunityTotalModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UICommunityTotal,
            "popup_wiki_2")
    --- @type UIPopupType
    self.type = UIPopupType.BLUR_POPUP
    self.bgDark = false
end

