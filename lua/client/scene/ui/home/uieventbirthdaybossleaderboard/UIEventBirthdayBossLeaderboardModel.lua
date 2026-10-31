--- @class UIEventBirthdayBossLeaderboardModel : UIBaseModel
UIEventBirthdayBossLeaderboardModel = Class(UIEventBirthdayBossLeaderboardModel, UIBaseModel)

--- @return void
function UIEventBirthdayBossLeaderboardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventBirthdayBossLeaderBoard, "birthday_boss_leader_board")
	self.bgDark = true

	--- @type List
	self.listRanking = nil
end

