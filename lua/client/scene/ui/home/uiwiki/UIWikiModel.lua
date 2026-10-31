--- @class UIWikiModel : UIBaseModel
UIWikiModel = Class(UIWikiModel, UIBaseModel)

--- @return void
function UIWikiModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIWiki,
			"popup_wiki")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = false
end

