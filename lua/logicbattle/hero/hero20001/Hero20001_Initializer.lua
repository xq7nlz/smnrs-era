--- @class Hero20001_Initializer
Hero20001_Initializer = Class(Hero20001_Initializer, HeroInitializer)

--- @return void
function Hero20001_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)

    self.myHero.attack = Hero20001_AttackStat(self.myHero)
    self.myHero.hp = Hero20001_HpStat(self.myHero)

    self.myHero.power = Hero20001_PowerStat(self.myHero)
end

--- @return void
function Hero20001_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20001_AttackListener(self.myHero)
end