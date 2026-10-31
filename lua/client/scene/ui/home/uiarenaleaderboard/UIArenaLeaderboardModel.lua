
--- @class UIArenaLeaderboardModel : UIBaseModel
UIArenaLeaderboardModel = Class(UIArenaLeaderboardModel, UIBaseModel)

--- @return void
function UIArenaLeaderboardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaLeaderboard, "arena_leader_board")
	self.bgDark = true

	--- @type List
	self.listRanking = nil
end

