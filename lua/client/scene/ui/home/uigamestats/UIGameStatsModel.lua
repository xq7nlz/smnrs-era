
--- @class UIGameStatsModel : UIBaseModel
UIGameStatsModel = Class(UIGameStatsModel, UIBaseModel)

--- @return void
function UIGameStatsModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.GameStats, "game_stats")
	XDebug.Log("this prefab is in prefab now, move to UIPool to check")
end

