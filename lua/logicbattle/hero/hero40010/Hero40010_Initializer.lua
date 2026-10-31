--- @class Hero40010_Initializer
Hero40010_Initializer = Class(Hero40010_Initializer, HeroInitializer)

--- @return void
function Hero40010_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attack = Hero40010_AttackStat(self.myHero)
end

--- @return void
function Hero40010_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40010_AttackListener(self.myHero)
    self.myHero.skillListener = Hero40010_SkillListener(self.myHero)
end
