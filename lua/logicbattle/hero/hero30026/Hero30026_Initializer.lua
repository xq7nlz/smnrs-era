--- @class Hero30026_Initializer
Hero30026_Initializer = Class(Hero30026_Initializer, HeroInitializer)

--- @return void
function Hero30026_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.battleListener = Hero30026_BattleListener(self.myHero)
    self.myHero.skillListener = Hero30026_SkillListener(self.myHero)
end
