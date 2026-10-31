--- @class Hero60014_Initializer
Hero60014_Initializer = Class(Hero60014_Initializer, HeroInitializer)

--- @return void
function Hero60014_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60014_AttackListener(self.myHero)
    self.myHero.battleListener = Hero60014_BattleListener(self.myHero)
end