
--- @class UIKazetsuBossLeaderboardModel : UIBaseModel
UIKazetsuBossLeaderboardModel = Class(UIKazetsuBossLeaderboardModel, UIBaseModel)

--- @return void
function UIKazetsuBossLeaderboardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIKazetsuBossLeaderboard, "kazetsu_boss_leader_board")
	self.bgDark = true

	--- @type List
	self.listRanking = nil
end

