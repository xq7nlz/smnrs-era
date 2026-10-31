--- @class Hero30024_Initializer
Hero30024_Initializer = Class(Hero30024_Initializer, HeroInitializer)

--- @return void
function Hero30024_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30024_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30024_SkillListener(self.myHero)
end
