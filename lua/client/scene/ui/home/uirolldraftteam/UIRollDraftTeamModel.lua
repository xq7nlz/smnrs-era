
--- @class UIRollDraftTeamModel : UIBaseModel
UIRollDraftTeamModel = Class(UIRollDraftTeamModel, UIBaseModel)

--- @return void
function UIRollDraftTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRollDraftTeam, "roll_draft_team")
	--- @type GameMode
	self.currentMode = nil

	--- @type List<HeroResource>
	self.listHeroResourceSelected = List()

	self.bgDark = false
end

