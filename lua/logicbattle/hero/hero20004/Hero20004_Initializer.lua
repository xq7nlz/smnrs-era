--- @class Hero20004_Initializer
Hero20004_Initializer = Class(Hero20004_Initializer, HeroInitializer)

--- @return void
function Hero20004_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20004_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20004_SkillListener(self.myHero)
end

--- @return void
function Hero20004_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero20004_BattleHelper(self.myHero)
end