--- @class Hero20007_Initializer
Hero20007_Initializer = Class(Hero20007_Initializer, HeroInitializer)

--- @return void
function Hero20007_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20007_AttackListener(self.myHero)
    self.myHero.battleListener = Hero20007_BattleListener(self.myHero)
end