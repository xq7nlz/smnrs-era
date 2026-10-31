--- @class UIFindeBossLeaderboardModel : UIBaseModel
UIFindeBossLeaderboardModel = Class(UIFindeBossLeaderboardModel, UIBaseModel)

--- @return void
function UIFindeBossLeaderboardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFindeBossLeaderboard, "kazetsu_boss_leader_board")
	self.bgDark = true

	--- @type List
	self.listRanking = nil
end

