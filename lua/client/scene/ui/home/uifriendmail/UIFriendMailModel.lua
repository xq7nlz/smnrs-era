
--- @class UIFriendMailModel : UIBaseModel
UIFriendMailModel = Class(UIFriendMailModel, UIBaseModel)

--- @return void
function UIFriendMailModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFriendMail, "friend_mail")

	self.bgDark = true
end

