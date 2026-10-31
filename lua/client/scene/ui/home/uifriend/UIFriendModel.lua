
--- @class UIFriendModel : UIBaseModel
UIFriendModel = Class(UIFriendModel, UIBaseModel)

--- @return void
function UIFriendModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFriend, "friend")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

