
--- @class UIPreviewFriendModel : UIBaseModel
UIPreviewFriendModel = Class(UIPreviewFriendModel, UIBaseModel)

--- @return void
function UIPreviewFriendModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewFriend, "friend_preview")

	--- @type number
	self.playerId = nil
	--- @type string
	self.userName = nil
	--- @type number
	self.avatar = nil
	--- @type number
	self.level = nil
	--- @type string
	self.guildName = nil
	--- @type BattleTeamInfo
	self.battleTeamInfo = nil
	--- @type boolean
	self.canAdd = nil
	--- @type boolean
	self.canDelete = nil
	--- @type boolean
	self.canBlock = nil
	--- @type boolean
	self.canSendMail = nil

	self.bgDark = true
end

