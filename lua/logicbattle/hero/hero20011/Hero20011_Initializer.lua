--- @class Hero20011_Initializer
Hero20011_Initializer = Class(Hero20011_Initializer, HeroInitializer)

--- @return void
function Hero20011_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20011_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20011_SkillListener(self.myHero)
end

--- @return void
function Hero20011_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero20011_BattleHelper(self.myHero)
end
