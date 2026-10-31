--- @class Hero60007_Initializer
Hero60007_Initializer = Class(Hero60007_Initializer, HeroInitializer)

--- @return void
function Hero60007_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60007_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60007_SkillListener(self.myHero)
end