--- @class Hero60022_Initializer
Hero60022_Initializer = Class(Hero60022_Initializer, HeroInitializer)

--- @return void
function Hero60022_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60022_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60022_SkillListener(self.myHero)
end