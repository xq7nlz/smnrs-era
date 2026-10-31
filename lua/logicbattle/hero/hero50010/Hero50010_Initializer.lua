--- @class Hero50010_Initializer
Hero50010_Initializer = Class(Hero50010_Initializer, HeroInitializer)

--- @return void
function Hero50010_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50010_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50010_SkillListener(self.myHero)
end

--- @return void
function Hero50010_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50010_BattleHelper(self.myHero)
end
