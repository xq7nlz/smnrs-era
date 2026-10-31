--- @class Hero60008_Initializer
Hero60008_Initializer = Class(Hero60008_Initializer, HeroInitializer)

--- @return void
function Hero60008_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60008_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60008_SkillListener(self.myHero)
end
