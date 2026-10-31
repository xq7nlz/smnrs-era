
--- @class UIHeroSummonInfoModel : UIBaseModel
UIHeroSummonInfoModel = Class(UIHeroSummonInfoModel, UIBaseModel)

--- @return void
function UIHeroSummonInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIHeroSummonInfo, "hero_summon_info")

	--- @type HeroResource
	self.heroResource = nil

	self.bgDark = true
end

