
--- @class UIHeroSummonModelRemake : UIBaseModel
UIHeroSummonModelRemake = Class(UIHeroSummonModelRemake, UIBaseModel)

--- @return void
function UIHeroSummonModelRemake:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIHeroSummonRemake, "hero_summon_remake")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    --- @type number
    self.timeSummon1 = 2.5
    --- @type number
    self.timeSummon10 = 1
    --- @type number
    self.timeShowHero = 2.5
    --- @type number
    self.timeShowButton = 2
    --- @type number
    self.starSize = 36.5
    --- @type ClientResourceDict
    self.money = nil
    --- @type HeroSummonData
    self.summonData = nil
    --- @type boolean
    self.enabledSummonResult = false
    --- @type number
    self.fillBarLength = 600
end


