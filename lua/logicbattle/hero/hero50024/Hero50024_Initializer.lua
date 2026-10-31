--- @class Hero50024_Initializer
Hero50024_Initializer = Class(Hero50024_Initializer, HeroInitializer)

--- @return void
function Hero50024_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50024_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50024_SkillListener(self.myHero)
end
