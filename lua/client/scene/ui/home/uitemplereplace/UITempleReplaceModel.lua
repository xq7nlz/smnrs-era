
--- @class UITempleReplaceModel : UIBaseModel
UITempleReplaceModel = Class(UITempleReplaceModel, UIBaseModel)

--- @return void
function UITempleReplaceModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITempleReplace, "temple_replace")
	--- @type number
	self.prefabHeroListPosY = 120
	--- @type number
	self.starSize = 66
	--- @type ClientResourceDict
	self.money = nil
	--- @type List --<HeroResource>
	self.heroResourceList = nil
	--- @type number
	self.selectedHero = nil
	--- @type HeroIconView
    self.selectedIconView = nil
	--- @type number
	self.convertedHero = nil
	--- @type number
	self.convertPrice = 0

	self.bgDark = false
end

