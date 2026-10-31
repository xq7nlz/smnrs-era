--- @class Hero20008_Initializer
Hero20008_Initializer = Class(Hero20008_Initializer, HeroInitializer)

--- @return void
function Hero20008_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero20008_HpStat(self.myHero)
end

--- @return void
function Hero20008_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20008_AttackListener(self.myHero)
end