
--- @class UIArena2Model : UIBaseModel
UIArena2Model = Class(UIArena2Model, UIBaseModel)

--- @return void
function UIArena2Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArena2, "arena2")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	--- @type GroupArenaRankingInBound
	self.listSingleArenaRankingInBound = nil

	---@type Dictionary
	self.cacheOtherPlayerRecord = Dictionary()
	---@type Dictionary
	self.cacheBattleRecord = Dictionary()

	self.bgDark = false
end

