--- @class Hero50023_Initializer
Hero50023_Initializer = Class(Hero50023_Initializer, HeroInitializer)

--- @return void
function Hero50023_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50023_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50023_SkillListener(self.myHero)
end
