--- @class Hero50005_Initializer
Hero50005_Initializer = Class(Hero50005_Initializer, HeroInitializer)

--- @return void
function Hero50005_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50005_AttackListener(self.myHero)
    self.myHero.battleListener = Hero50005_BattleListener(self.myHero)
end