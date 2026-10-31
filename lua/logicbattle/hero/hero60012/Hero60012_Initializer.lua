--- @class Hero60012_Initializer
Hero60012_Initializer = Class(Hero60012_Initializer, HeroInitializer)

--- @return void
function Hero60012_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60012_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60012_SkillListener(self.myHero)
end
