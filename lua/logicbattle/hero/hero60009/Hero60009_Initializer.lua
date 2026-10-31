--- @class Hero60009_Initializer
Hero60009_Initializer = Class(Hero60009_Initializer, HeroInitializer)

--- @return void
function Hero60009_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60009_AttackListener(self.myHero)
end